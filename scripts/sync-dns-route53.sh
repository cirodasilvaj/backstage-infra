#!/usr/bin/env bash
# ==============================================================================
# CLI Synchronizer: Route 53 DNS + Automated ACM SSL/TLS Wildcard Certificate
# ==============================================================================
set -euo pipefail

echo "🔍 Identifying active AWS Account and Hosted Zone in Route 53..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "Unknown")
echo "🏢 Active AWS Account: ${ACCOUNT_ID}"

# 1. Discover public Hosted Zone
ZONE_INFO=""

# Strategy A: jq filter on Route 53 output
if command -v jq >/dev/null 2>&1; then
  ALL_ZONES=$(aws route53 list-hosted-zones --output json 2>/dev/null || true)
  if [ -n "$ALL_ZONES" ]; then
    ZONE_INFO=$(echo "$ALL_ZONES" | jq -c '[.HostedZones[] | select((.Config.PrivateZone == false or .Config.PrivateZone == null) and (.Name | contains("realhandsonlabs.net")))] | first // empty' 2>/dev/null || true)
    if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
      ZONE_INFO=$(echo "$ALL_ZONES" | jq -c '[.HostedZones[] | select(.Config.PrivateZone == false or .Config.PrivateZone == null)] | first // empty' 2>/dev/null || true)
    fi
  fi
fi

# Strategy B: JMESPath filter fallback
if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, 'realhandsonlabs.net') && Config.PrivateZone == \`false\`] | [0]" --output json 2>/dev/null || true)
fi

if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?Config.PrivateZone == \`false\`] | [0]" --output json 2>/dev/null || true)
fi

# Strategy C: Account ID match fallback
if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, '${ACCOUNT_ID}')] | [0]" --output json 2>/dev/null || true)
fi

if [ -z "$ZONE_INFO" ] || [ "$ZONE_INFO" = "null" ]; then
  echo "⚠️ No public Hosted Zone found in Route 53."
  exit 1
fi

ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.Id' | sed 's|/hostedzone/||')
ZONE_NAME=$(echo "$ZONE_INFO" | jq -r '.Name' | sed 's/\.$//')

echo "✅ Route 53 Hosted Zone found: ${ZONE_NAME} (ID: ${ZONE_ID})"

# ------------------------------------------------------------------------------
# ACM Step: Wildcard SSL/TLS Certificate Request and DNS Validation
# ------------------------------------------------------------------------------
echo "🔐 Checking Wildcard SSL/TLS Certificate (*.${ZONE_NAME}) in AWS ACM..."
CERT_ARN=$(aws acm list-certificates --query "CertificateSummaryList[?DomainName=='*.${ZONE_NAME}'].CertificateArn | [0]" --output text 2>/dev/null || true)

if [ "$CERT_ARN" = "None" ] || [ -z "$CERT_ARN" ]; then
  echo "🚀 Requesting new Wildcard Certificate in AWS Certificate Manager (ACM)..."
  CERT_ARN=$(aws acm request-certificate \
    --domain-name "*.${ZONE_NAME}" \
    --subject-alternative-names "${ZONE_NAME}" \
    --validation-method DNS \
    --tags Key=Project,Value=apps-demo-2026 Key=Environment,Value=sandbox Key=ManagedBy,Value=cli Key=CostCenter,Value=devops-platform-cloud \
    --query CertificateArn --output text)
  echo "✅ ACM Certificate requested: ${CERT_ARN}"

  echo "⏳ Waiting for ACM DNS validation records to become available..."
  sleep 4
fi

VAL_NAME=$(aws acm describe-certificate --certificate-arn "$CERT_ARN" --query "Certificate.DomainValidationOptions[0].ResourceRecord.Name" --output text 2>/dev/null || true)
VAL_VALUE=$(aws acm describe-certificate --certificate-arn "$CERT_ARN" --query "Certificate.DomainValidationOptions[0].ResourceRecord.Value" --output text 2>/dev/null || true)

if [ -n "$VAL_NAME" ] && [ "$VAL_NAME" != "None" ]; then
  echo "📝 Publishing ACM validation CNAME record to Route 53..."
  echo "   ${VAL_NAME} -> ${VAL_VALUE}"
  aws route53 change-resource-record-sets --hosted-zone-id "$ZONE_ID" --change-batch "{
    \"Comment\": \"ACM DNS Validation for *.${ZONE_NAME}\",
    \"Changes\": [{
      \"Action\": \"UPSERT\",
      \"ResourceRecordSet\": {
        \"Name\": \"${VAL_NAME}\",
        \"Type\": \"CNAME\",
        \"TTL\": 60,
        \"ResourceRecords\": [{\"Value\": \"${VAL_VALUE}\"}]
      }
    }]
  }" >/dev/null || true
  echo "✅ ACM validation record published to Route 53."
fi

# ------------------------------------------------------------------------------
# Demo Apps CNAME Step
# ------------------------------------------------------------------------------
SERVICES=(
  "python:apps-demo:python-app"
  "dotnet:apps-demo:dotnet-csharp-app"
)

CHANGES=()

for item in "${SERVICES[@]}"; do
  IFS=":" read -r SUBDOMAIN NAMESPACE SVC_NAME <<< "$item"
  
  ELB_HOSTNAME=$(kubectl get svc "$SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
  
  if [ -n "$ELB_HOSTNAME" ]; then
    FQDN="${SUBDOMAIN}.${ZONE_NAME}"
    echo "🔗 Associating ${FQDN} -> ${ELB_HOSTNAME}"
    CHANGES+=("{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"${FQDN}\",\"Type\":\"CNAME\",\"TTL\":60,\"ResourceRecords\":[{\"Value\":\"${ELB_HOSTNAME}\"}]}}")
  else
    echo "⏳ Service '${SVC_NAME}' in namespace '${NAMESPACE}' does not have an external LoadBalancer ready yet."
  fi
done

if [ ${#CHANGES[@]} -gt 0 ]; then
  CHANGES_JSON=$(IFS=,; echo "${CHANGES[*]}")
  BATCH_JSON="{\"Comment\":\"Auto-sync Apps endpoints to Route 53 with ACM SSL\",\"Changes\":[${CHANGES_JSON}]}"
  
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "$BATCH_JSON" >/dev/null
    
  echo ""
  echo "=============================================================================="
  echo "🎉 Apps Route 53 DNS & ACM SSL/TLS certificate configured successfully!"
  echo "=============================================================================="
  echo "🔒 ACM Certificate ARN: ${CERT_ARN}"
  echo "🌐 Available HTTPS and HTTP endpoints:"
  for item in "${SERVICES[@]}"; do
    IFS=":" read -r SUBDOMAIN _ _ <<< "$item"
    echo " 👉 https://${SUBDOMAIN}.${ZONE_NAME}  (or http://${SUBDOMAIN}.${ZONE_NAME})"
  done
  echo "=============================================================================="
fi
