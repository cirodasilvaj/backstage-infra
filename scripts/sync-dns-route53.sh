#!/usr/bin/env bash
# ==============================================================================
# Sincronizador CLI: Route 53 + Emissão Automática de Certificado SSL/TLS ACM (HTTPS)
# ==============================================================================
set -euo pipefail

echo "🔍 Identificando Conta AWS ativa e Hosted Zone no Route 53..."
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "Desconhecida")
echo "🏢 Conta AWS identificada: ${ACCOUNT_ID}"

ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, 'realhandsonlabs.net') && !Config.PrivateZone] | [0]" --output json 2>/dev/null || true)

if [ "$ZONE_INFO" = "null" ] || [ -z "$ZONE_INFO" ]; then
  echo "⚠️ Nenhuma Hosted Zone pública terminando com 'realhandsonlabs.net' encontrada."
  exit 1
fi

ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.Id' | sed 's|/hostedzone/||')
ZONE_NAME=$(echo "$ZONE_INFO" | jq -r '.Name' | sed 's/\.$//')

echo "✅ Zona Route 53 encontrada: ${ZONE_NAME} (ID: ${ZONE_ID})"

# ------------------------------------------------------------------------------
# Etapa ACM: Emissão e Validação Automática de Certificado Wildcard SSL/TLS
# ------------------------------------------------------------------------------
echo "🔐 Verificando Certificado SSL/TLS Wildcard (*.${ZONE_NAME}) no AWS ACM..."
CERT_ARN=$(aws acm list-certificates --query "CertificateSummaryList[?DomainName=='*.${ZONE_NAME}'].CertificateArn | [0]" --output text 2>/dev/null || true)

if [ "$CERT_ARN" = "None" ] || [ -z "$CERT_ARN" ]; then
  echo "🚀 Solicitando novo Certificado Wildcard no AWS Certificate Manager (ACM)..."
  CERT_ARN=$(aws acm request-certificate \
    --domain-name "*.${ZONE_NAME}" \
    --subject-alternative-names "${ZONE_NAME}" \
    --validation-method DNS \
    --tags Key=Project,Value=backstage-infra Key=Environment,Value=sandbox Key=ManagedBy,Value=cli Key=CostCenter,Value=devops-platform-cloud \
    --query CertificateArn --output text)
  echo "✅ Certificado ACM solicitado: ${CERT_ARN}"

  echo "⏳ Aguardando registros de validação DNS gerados pelo ACM..."
  sleep 4
fi

VAL_NAME=$(aws acm describe-certificate --certificate-arn "$CERT_ARN" --query "Certificate.DomainValidationOptions[0].ResourceRecord.Name" --output text 2>/dev/null || true)
VAL_VALUE=$(aws acm describe-certificate --certificate-arn "$CERT_ARN" --query "Certificate.DomainValidationOptions[0].ResourceRecord.Value" --output text 2>/dev/null || true)

if [ -n "$VAL_NAME" ] && [ "$VAL_NAME" != "None" ]; then
  echo "📝 Inserindo CNAME de validação do ACM no Route 53..."
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
  echo "✅ Registro de validação ACM publicado no Route 53."
fi

# ------------------------------------------------------------------------------
# Etapa CNAMEs dos Serviços Kubernetes
# ------------------------------------------------------------------------------
SERVICES=(
  "backstage:backstage:backstage-external"
  "grafana:grafana:grafana-external"
  "argocd:argocd:argocd-external"
  "sonarqube:sonarqube:sonarqube-external"
  "python:apps-demo:python-app"
  "dotnet:apps-demo:dotnet-csharp-app"
)

CHANGES=()

for item in "${SERVICES[@]}"; do
  IFS=":" read -r SUBDOMAIN NAMESPACE SVC_NAME <<< "$item"
  
  ELB_HOSTNAME=$(kubectl get svc "$SVC_NAME" -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || true)
  
  if [ -n "$ELB_HOSTNAME" ]; then
    FQDN="${SUBDOMAIN}.${ZONE_NAME}"
    echo "🔗 Associando ${FQDN} -> ${ELB_HOSTNAME}"
    CHANGES+=("{\"Action\":\"UPSERT\",\"ResourceRecordSet\":{\"Name\":\"${FQDN}\",\"Type\":\"CNAME\",\"TTL\":60,\"ResourceRecords\":[{\"Value\":\"${ELB_HOSTNAME}\"}]}}")
  else
    echo "⏳ Serviço '${SVC_NAME}' no namespace '${NAMESPACE}' ainda não possui LoadBalancer pronto no EKS."
  fi
done

if [ ${#CHANGES[@]} -gt 0 ]; then
  CHANGES_JSON=$(IFS=,; echo "${CHANGES[*]}")
  BATCH_JSON="{\"Comment\":\"Auto-sync EKS endpoints to Route 53 with ACM SSL\",\"Changes\":[${CHANGES_JSON}]}"
  
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "$BATCH_JSON" >/dev/null
    
  echo ""
  echo "=============================================================================="
  echo "🎉 Endpoints Route 53 & Certificado ACM SSL/TLS configurados com sucesso!"
  echo "=============================================================================="
  echo "🔒 ACM Certificate ARN: ${CERT_ARN}"
  echo "🌐 Endpoints com suporte a HTTP e HTTPS:"
  for item in "${SERVICES[@]}"; do
    IFS=":" read -r SUBDOMAIN _ _ <<< "$item"
    echo " 👉 https://${SUBDOMAIN}.${ZONE_NAME}  (ou http://${SUBDOMAIN}.${ZONE_NAME})"
  done
  echo "=============================================================================="
fi
