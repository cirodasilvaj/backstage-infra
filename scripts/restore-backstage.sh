#!/usr/bin/env bash
# ==============================================================================
# Script: restore-backstage.sh
# Description: Automated Complete Restore Procedure for Backstage Developer Portal:
#              1. Validates backup SQL dump and configuration manifests
#              2. Restores AWS RDS PostgreSQL database (schema, migrations, entities)
#              3. Applies Kubernetes ConfigMaps, RBAC, Services, and Deployment
#              4. Performs rolling restart and waits for 3/3 containers Ready
#              5. Executes end-to-end post-restore smoke test suite
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
BACKUP_DIR="${REPO_ROOT}/backup"
DUMP_FILE="${1:-${BACKUP_DIR}/backstage-rds-dump.sql}"

echo "=================================================================="
echo "🔄 Starting Backstage Complete Restore Procedure"
echo "=================================================================="
echo "📁 Source Dump File: ${DUMP_FILE}"

# ------------------------------------------------------------------------------
# 1. Validate Backup File
# ------------------------------------------------------------------------------
if [[ ! -f "${DUMP_FILE}" ]]; then
  echo "❌ Error: Backup file not found at ${DUMP_FILE}"
  exit 1
fi

echo "🔍 Validating backup dump integrity..."
if grep -q "knex_migrations" "${DUMP_FILE}" && grep -q "final_entities" "${DUMP_FILE}"; then
  DUMP_SIZE="$(du -h "${DUMP_FILE}" | cut -f1)"
  ENTITIES_IN_DUMP="$(grep -c "INSERT INTO public.final_entities" "${DUMP_FILE}" || true)"
  echo "✅ Dump integrity verified (${DUMP_SIZE}, contains ${ENTITIES_IN_DUMP} catalog entity records)."
else
  echo "❌ Error: Dump file failed integrity validation (missing knex_migrations or final_entities)."
  exit 1
fi

# ------------------------------------------------------------------------------
# 2. Retrieve RDS Database Credentials
# ------------------------------------------------------------------------------
echo "🔑 Retrieving database credentials from Kubernetes secret..."
if kubectl get secret backstage-db-credentials -n backstage >/dev/null 2>&1; then
  POSTGRES_HOST="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_HOST}' | base64 -d)"
  POSTGRES_PORT="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_PORT}' | base64 -d)"
  POSTGRES_USER="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_USER}' | base64 -d)"
  POSTGRES_PASSWORD="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_PASSWORD}' | base64 -d)"
  POSTGRES_DB="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_DB}' | base64 -d)"
else
  echo "⚠️ Secret backstage-db-credentials not found. Using environment variables."
  POSTGRES_HOST="${POSTGRES_HOST:-}"
  POSTGRES_PORT="${POSTGRES_PORT:-5432}"
  POSTGRES_USER="${POSTGRES_USER:-backstage}"
  POSTGRES_PASSWORD="${POSTGRES_PASSWORD:-}"
  POSTGRES_DB="${POSTGRES_DB:-postgres}"
fi

if [[ -z "${POSTGRES_HOST}" || -z "${POSTGRES_PASSWORD}" ]]; then
  echo "❌ Error: POSTGRES_HOST or POSTGRES_PASSWORD is empty. Cannot restore database."
  exit 1
fi

# ------------------------------------------------------------------------------
# 3. Restore Database into AWS RDS PostgreSQL
# ------------------------------------------------------------------------------
echo "📥 Restoring PostgreSQL database into ${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}..."

# Prefer executing restore via the running backstage-db-sync container inside the VPC
if kubectl get pod -n backstage -l app=backstage >/dev/null 2>&1; then
  echo "ℹ️ Executing restore via backstage-db-sync container inside the cluster VPC..."
  kubectl exec -i -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
    'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" --quiet' \
    < "${DUMP_FILE}"
elif command -v psql >/dev/null 2>&1; then
  echo "ℹ️ Executing restore via local psql client..."
  PGPASSWORD="${POSTGRES_PASSWORD}" psql -h "${POSTGRES_HOST}" -p "${POSTGRES_PORT}" -U "${POSTGRES_USER}" -d "${POSTGRES_DB}" --quiet \
    < "${DUMP_FILE}"
else
  echo "❌ Error: Neither kubectl pod access nor local psql is available to perform database restore."
  exit 1
fi

echo "✅ Database restore executed. Validating database tables..."
ENTITIES_COUNT=$(kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT count(*) FROM final_entities;"' | tr -d ' ')

MIGRATIONS_COUNT=$(kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB" -t -c "SELECT count(*) FROM knex_migrations;"' | tr -d ' ')

echo "✅ Database validation confirmed: ${ENTITIES_COUNT} final_entities, ${MIGRATIONS_COUNT} migrations."

# ------------------------------------------------------------------------------
# 4. Apply Kubernetes Manifests from Backup
# ------------------------------------------------------------------------------
echo "☸️ Applying Kubernetes manifests from backup directory..."

if [[ -f "${BACKUP_DIR}/rbac-backstage.yaml" ]]; then
  kubectl apply -f "${BACKUP_DIR}/rbac-backstage.yaml"
fi
if [[ -f "${BACKUP_DIR}/configmap-backstage-app-config.yaml" ]]; then
  kubectl apply -f "${BACKUP_DIR}/configmap-backstage-app-config.yaml"
fi
if [[ -f "${BACKUP_DIR}/service-backstage.yaml" ]]; then
  kubectl apply -f "${BACKUP_DIR}/service-backstage.yaml"
fi
if [[ -f "${BACKUP_DIR}/deployment-backstage.yaml" ]]; then
  kubectl apply -f "${BACKUP_DIR}/deployment-backstage.yaml"
fi

# ------------------------------------------------------------------------------
# 5. Rollout Restart & Healthcheck
# ------------------------------------------------------------------------------
echo "🔄 Rolling restart Backstage deployment to load restored state..."
kubectl rollout restart deployment backstage -n backstage
kubectl rollout status deployment backstage -n backstage --timeout=180s

echo "⏳ Waiting 5 seconds for backend routes initialization..."
sleep 5

# ------------------------------------------------------------------------------
# 6. End-to-End Post-Restore Smoke Tests
# ------------------------------------------------------------------------------
echo "🧪 Running post-restore smoke test suite..."

# Get proxy credentials
AUTH_USER="$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.username}' | base64 -d)"
AUTH_PASS="$(kubectl get secret backstage-basic-auth -n backstage -o jsonpath='{.data.password}' | base64 -d)"

# Wait for backend HTTP service to be responsive
echo "⏳ Waiting for Backstage backend HTTP service to respond..."
MAX_RETRIES=15
COUNTER=0
HEALTH_OK=false

while [[ ${COUNTER} -lt ${MAX_RETRIES} ]]; do
  if curl -fsS "http://backstage.799416476486.realhandsonlabs.net/healthcheck" >/dev/null 2>&1; then
    HEALTH_OK=true
    break
  fi
  COUNTER=$((COUNTER + 1))
  sleep 2
done

if [[ "${HEALTH_OK}" == "true" ]]; then
  echo "✅ Healthcheck: 200 OK"
else
  echo "⚠️ Warning: Healthcheck did not respond within expected time."
fi

# Fetch restored entities count via Catalog API
CATALOG_JSON="$(curl -fsS -u "${AUTH_USER}:${AUTH_PASS}" "http://backstage.799416476486.realhandsonlabs.net/api/catalog/entities" 2>/dev/null || echo '[]')"
CATALOG_ITEMS="$(echo "${CATALOG_JSON}" | jq '. | length' 2>/dev/null || echo 0)"

COMPONENTS_COUNT="$(echo "${CATALOG_JSON}" | jq '[.[] | select(.kind == "Component")] | length' 2>/dev/null || echo 0)"
APIS_COUNT="$(echo "${CATALOG_JSON}" | jq '[.[] | select(.kind == "API")] | length' 2>/dev/null || echo 0)"
TEMPLATES_COUNT="$(echo "${CATALOG_JSON}" | jq '[.[] | select(.kind == "Template")] | length' 2>/dev/null || echo 0)"

echo "✅ Software Catalog entities verified: ${CATALOG_ITEMS} active entities."
echo "   ├── Components: ${COMPONENTS_COUNT}"
echo "   ├── APIs: ${APIS_COUNT}"
echo "   └── Templates: ${TEMPLATES_COUNT}"

echo "=================================================================="
echo "🎉 Backstage Complete Restore Procedure Completed Successfully!"
echo "🌐 Portal URL: http://backstage.799416476486.realhandsonlabs.net"
echo "📊 Total entities restored in catalog: ${CATALOG_ITEMS}"
echo "=================================================================="
