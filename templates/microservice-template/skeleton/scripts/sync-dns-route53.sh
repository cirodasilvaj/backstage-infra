#!/usr/bin/env bash
# ==============================================================================
# Sync application LoadBalancer with Route 53 DNS and ACM SSL/TLS
# ==============================================================================
set -euo pipefail

APP_NAME="${{ values.component_id }}"
SVC_NAME="${APP_NAME}-external"
NAMESPACE="apps-demo"

echo "🔍 Searching for public Hosted Zone in Route 53..."
ZONE_INFO=""
if command -v jq >/dev/null 2>&1; then
  ALL_ZONES=$(aws route53 list-hosted-zones --output json 2>/dev/null || true)
  if [ -n "$ALL_ZONES" ]; then
    ZONE_INFO=$(echo "$ALL_ZONES" | jq -c '[.HostedZones[] | select((.Config.PrivateZone == false or .Config.PrivateZone == null) and (.Name | contains("realhandsonlabs.net")))] | first // empty' 2>/dev/null || true)
    if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
      ZONE_INFO=$(echo "$ALL_ZONES" | jq -c '[.HostedZones[] | select(.Config.PrivateZone == false or .Config.PrivateZone == null)] | first // empty' 2>/dev/null || true)
    fi
  fi
fi

if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, 'realhandsonlabs.net') && Config.PrivateZone == \`false\`] | [0]" --output json 2>/dev/null || true)
fi

if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?Config.PrivateZone == \`false\`] | [0]" --output json 2>/dev/null || true)
fi

if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  echo "⚠️ No public Hosted Zone found in Route 53."
  exit 0
fi

ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.Id' | sed 's|/hostedzone/||')
ZONE_NAME=$(echo "$ZONE_INFO" | jq -r '.Name' | sed 's/\.$//')

echo "⏳ Getting LoadBalancer hostname for '${SVC_NAME}'..."
ELB_HOSTNAME=$(kubectl get svc "$SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)

if [ -z "$ELB_HOSTNAME" ]; then
  echo "⏳ LoadBalancer is still provisioning in EKS. Please wait."
  exit 0
fi

FQDN="${APP_NAME}.${ZONE_NAME}"
echo "🔗 Mapping ${FQDN} -> ${ELB_HOSTNAME}"

aws route53 change-resource-record-sets \
  --hosted-zone-id "$ZONE_ID" \
  --change-batch "{
    \"Comment\": \"Auto-sync ${APP_NAME} to Route 53\",
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"${FQDN}\",
        \"Type\": \"CNAME\",
        \"TTL\": 60,
        \"ResourceRecords\": [{\"Value\": \"${ELB_HOSTNAME}\"}]
      }
    }]
  }" >/dev/null

echo "🎉 Application accessible at https://${FQDN} (or http://${FQDN})"
