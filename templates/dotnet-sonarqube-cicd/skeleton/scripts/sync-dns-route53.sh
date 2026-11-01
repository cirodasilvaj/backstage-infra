#!/usr/bin/env bash
# ==============================================================================
# Sincroniza o LoadBalancer da aplicacao com o Route 53 e ACM SSL/TLS
# ==============================================================================
set -euo pipefail

APP_NAME="${{ values.component_id }}"
SVC_NAME="${APP_NAME}-external"
NAMESPACE="apps-demo"

echo "🔍 Buscando Hosted Zone pública no Route 53..."
ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, 'realhandsonlabs.net') && !Config.PrivateZone] | [0]" --output json 2>/dev/null || true)

if [ "$ZONE_INFO" = "null" ] || [ -z "$ZONE_INFO" ]; then
  echo "⚠️ Nenhuma Hosted Zone pública encontrada."
  exit 0
fi

ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.Id' | sed 's|/hostedzone/||')
ZONE_NAME=$(echo "$ZONE_INFO" | jq -r '.Name' | sed 's/\.$//')

echo "⏳ Obtendo hostname do LoadBalancer para '${SVC_NAME}'..."
ELB_HOSTNAME=$(kubectl get svc "$SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)

if [ -z "$ELB_HOSTNAME" ]; then
  echo "⏳ LoadBalancer ainda provisionando no EKS. Aguarde alguns instantes."
  exit 0
fi

FQDN="${APP_NAME}.${ZONE_NAME}"
echo "🔗 Mapeando ${FQDN} -> ${ELB_HOSTNAME}"

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

echo "🎉 Aplicação acessível em https://${FQDN}"
