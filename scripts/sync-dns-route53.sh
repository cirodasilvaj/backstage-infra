#!/usr/bin/env bash
# ==============================================================================
# Sincronizador CLI de Endpoints EKS com Route 53 (Ambiente Efêmero de Lab)
# ==============================================================================
set -euo pipefail

echo "🔍 Buscando Hosted Zone pública (*realhandsonlabs.net) no Route 53..."
ZONE_INFO=$(aws route53 list-hosted-zones --query "HostedZones[?contains(Name, 'realhandsonlabs.net') && !Config.PrivateZone] | [0]" --output json 2>/dev/null || true)

if [ "$ZONE_INFO" = "null" ] || [ -z "$ZONE_INFO" ]; then
  echo "⚠️ Nenhuma Hosted Zone pública terminando com 'realhandsonlabs.net' encontrada."
  exit 1
fi

ZONE_ID=$(echo "$ZONE_INFO" | jq -r '.Id' | sed 's|/hostedzone/||')
ZONE_NAME=$(echo "$ZONE_INFO" | jq -r '.Name' | sed 's/\.$//')

echo "✅ Zona Route 53 encontrada: ${ZONE_NAME} (ID: ${ZONE_ID})"

# Mapeamento de subdomínios para os Services no EKS: "subdominio:namespace:service_name"
SERVICES=(
  "backstage:backstage:backstage-external"
  "grafana:grafana:grafana-external"
  "argocd:argocd:argocd-external"
  "sonarqube:sonarqube:sonarqube-external"
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
  BATCH_JSON="{\"Comment\":\"Auto-sync EKS endpoints to Route 53\",\"Changes\":[${CHANGES_JSON}]}"
  
  aws route53 change-resource-record-sets \
    --hosted-zone-id "$ZONE_ID" \
    --change-batch "$BATCH_JSON" >/dev/null
    
  echo ""
  echo "=============================================================================="
  echo "🎉 Endpoints Route 53 sincronizados com sucesso!"
  echo "=============================================================================="
  for item in "${SERVICES[@]}"; do
    IFS=":" read -r SUBDOMAIN _ _ <<< "$item"
    echo " 👉 http://${SUBDOMAIN}.${ZONE_NAME}"
  done
  echo "=============================================================================="
fi
