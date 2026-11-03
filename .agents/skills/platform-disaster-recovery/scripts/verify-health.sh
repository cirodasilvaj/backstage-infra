#!/usr/bin/env bash
# ==============================================================================
# Script: verify-health.sh
# Purpose: Comprehensive post-deploy/restore verification and smoke test
# ==============================================================================
set -euo pipefail

echo "=================================================================="
echo "🏥 PLATFORM END-TO-END HEALTH & SMOKE TEST SUITE (HTTPS)"
echo "=================================================================="

# Discover Domain or LoadBalancers
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null || echo "unknown")
ZONE_NAME=$(aws route53 list-hosted-zones --output json 2>/dev/null | jq -r '[.HostedZones[] | select(.Config.PrivateZone == false or .Config.PrivateZone == null)] | first | .Name // empty' | sed 's/\.$//' || true)

echo "🏢 AWS Account ID: ${ACCOUNT_ID}"
if [ -n "$ZONE_NAME" ]; then
  echo "🌐 Route 53 Domain: ${ZONE_NAME}"
fi
echo "=================================================================="

# Function to test an HTTP/HTTPS endpoint
test_endpoint() {
  local name="$1"
  local url="$2"
  local expected_pattern="$3"
  local auth="${4:-}"
  
  echo -n "• Testing ${name} (${url})... "
  
  local curl_opts=(-s -k -L --max-time 10)
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

AUTH_USER=$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.username}' 2>/dev/null | base64 -d || echo "admin")
AUTH_PASS=$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.password}' 2>/dev/null | base64 -d || echo "Backstage@2026")

# 1. Backstage HTTPS
test_endpoint "Backstage Health (HTTPS)" "https://backstage.${ZONE_NAME}/healthcheck" "ok" "" || true
test_endpoint "Backstage Catalog API (HTTPS)" "https://backstage.${ZONE_NAME}/api/catalog/entities" "metadata" "${AUTH_USER}:${AUTH_PASS}" || true

# 2. SonarQube HTTPS
test_endpoint "SonarQube System Status (HTTPS)" "https://sonarqube.${ZONE_NAME}/api/system/status" "UP" "" || true

# 3. Grafana HTTPS
test_endpoint "Grafana Health (HTTPS)" "https://grafana.${ZONE_NAME}/api/health" "ok" "" || true

# 4. ArgoCD HTTPS
test_endpoint "ArgoCD Web Console (HTTPS)" "https://argocd.${ZONE_NAME}" "Argo CD" "" || true

# 5. Workloads & Microservices HTTPS
test_endpoint "Node.js Demo22 (HTTPS)" "https://demo22.${ZONE_NAME}/api/info" "Hello World" "" || true
test_endpoint "Python Flask App (HTTPS)" "https://python.${ZONE_NAME}/healthz" "healthy" "" || true
test_endpoint "Dotnet C# App (HTTPS)" "https://dotnet.${ZONE_NAME}/healthz" "healthy" "" || true
test_endpoint "Scaffolder Starter (HTTPS)" "https://starter.${ZONE_NAME}/api/info" "scaffolder" "" || true

echo "=================================================================="
echo "📊 KUBERNETES WORKLOAD SUMMARY"
echo "=================================================================="
kubectl get deployments -A -l "app.kubernetes.io/part-of=kube-demo-2026" 2>/dev/null || true
kubectl get pods -n apps-demo 2>/dev/null || true
echo "=================================================================="
echo "🎉 Health check completed!"
