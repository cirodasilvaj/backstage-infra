#!/usr/bin/env bash
# ==============================================================================
# Script: verify-health.sh
# Purpose: Comprehensive post-deploy/restore verification and smoke test
# ==============================================================================
set -euo pipefail

echo "=================================================================="
echo "🏥 PLATFORM END-TO-END HEALTH & SMOKE TEST SUITE"
echo "=================================================================="

# Discover Domain or LoadBalancers
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "unknown")
ZONE_NAME=$(aws route53 list-hosted-zones --output json 2>/dev/null | jq -r '[.HostedZones[] | select(.Config.PrivateZone == false or .Config.PrivateZone == null)] | first | .Name // empty' | sed 's/\.$//' || true)

echo "🏢 AWS Account ID: ${ACCOUNT_ID}"
if [ -n "$ZONE_NAME" ]; then
  echo "🌐 Route 53 Domain: ${ZONE_NAME}"
fi
echo "=================================================================="

# Function to test an HTTP endpoint
test_endpoint() {
  local name="$1"
  local url="$2"
  local expected_pattern="$3"
  local auth="${4:-}"
  
  echo -n "• Testing ${name} (${url})... "
  
  local curl_opts=(-s -L --max-time 10)
  if [ -n "$auth" ]; then
    curl_opts+=(-u "$auth")
  fi
  
  local response
  response=$(curl "${curl_opts[@]}" "$url" 2>&1 || echo "ERROR")
  
  if echo "$response" | grep -qiE "$expected_pattern"; then
    echo "✅ HEALTHY"
    return 0
  else
    echo "⚠️ WARNING (Expected '${expected_pattern}', received: $(echo "$response" | head -n 1 | cut -c 1-60))"
    return 1
  fi
}

# 1. Backstage
BS_LB=$(kubectl get svc backstage-external -n backstage -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
BS_URL="http://${BS_LB}:7007"
if [ -n "$ZONE_NAME" ]; then
  BS_URL="http://backstage.${ZONE_NAME}"
fi
AUTH_USER=$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.username}' 2>/dev/null | base64 -d || echo "admin")
AUTH_PASS=$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.password}' 2>/dev/null | base64 -d || echo "Backstage@2026")

test_endpoint "Backstage Health" "${BS_URL}/healthcheck" "ok" "" || true
test_endpoint "Backstage Catalog API" "${BS_URL}/api/catalog/entities" "metadata" "${AUTH_USER}:${AUTH_PASS}" || true

# 2. SonarQube
SQ_LB=$(kubectl get svc sonarqube-external -n sonarqube -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
SQ_URL="http://${SQ_LB}:9000"
if [ -n "$ZONE_NAME" ]; then
  SQ_URL="http://sonarqube.${ZONE_NAME}"
fi
test_endpoint "SonarQube System Status" "${SQ_URL}/api/system/status" "UP" "" || true

# 3. Grafana
GRAFANA_LB=$(kubectl get svc grafana -n grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
GRAFANA_URL="http://${GRAFANA_LB}"
if [ -n "$ZONE_NAME" ]; then
  GRAFANA_URL="http://grafana.${ZONE_NAME}"
fi
test_endpoint "Grafana Health" "${GRAFANA_URL}/api/health" "ok" "" || true

# 4. ArgoCD
ARGO_LB=$(kubectl get svc argocd-server -n argocd -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
ARGO_URL="https://${ARGO_LB}"
if [ -n "$ZONE_NAME" ]; then
  ARGO_URL="http://argocd.${ZONE_NAME}"
fi
test_endpoint "ArgoCD Web Console" "${ARGO_URL}" "Argo CD" "" || true

# 5. Microservices
NODE_LB=$(kubectl get svc bkstg-made-nodejs-demo22-external -n apps-demo -o jsonpath='{.status.loadBalancer.ingress[0].hostname}' 2>/dev/null || echo "")
if [ -n "$NODE_LB" ]; then
  test_endpoint "Node.js Microservice (Live)" "http://${NODE_LB}/api/info" "Hello World" "" || true
fi

echo "=================================================================="
echo "📊 KUBERNETES WORKLOAD SUMMARY"
echo "=================================================================="
kubectl get deployments -A -l "app.kubernetes.io/part-of=kube-demo-2026" 2>/dev/null || true
kubectl get pods -n apps-demo 2>/dev/null || true
echo "=================================================================="
echo "🎉 Health check completed!"
