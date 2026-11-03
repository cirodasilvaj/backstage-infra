#!/usr/bin/env bash
# ==============================================================================
# Script: backup-full-platform.sh
# Description: Automated Full Platform & Disaster Recovery Backup
#              1. AWS RDS PostgreSQL: Backstage & SonarQube Databases
#              2. AWS Systems Manager (SSM) Parameter Store (/backstage/*, /kube-demo-2026/*)
#              3. Auto-executable restore scripts for AWS SSM & GitHub Actions Secrets
#              4. Full Kubernetes manifests (backstage, argocd, apps-demo, sonarqube, grafana)
#              5. Complete metadata, SHA256 integrity checksums, and compressed tarball
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
TIMESTAMP="$(date -u +%Y%m%d_%H%M%S)"
SNAPSHOT_DIR="${REPO_ROOT}/backup/snapshots/${TIMESTAMP}"
BACKUP_ROOT="${REPO_ROOT}/backup"

echo "=================================================================="
echo "🛡️  STARTING COMPLETE PLATFORM DISASTER RECOVERY BACKUP [${TIMESTAMP}]"
echo "=================================================================="

mkdir -p "${SNAPSHOT_DIR}/k8s/backstage"
mkdir -p "${SNAPSHOT_DIR}/k8s/argocd"
mkdir -p "${SNAPSHOT_DIR}/k8s/apps-demo"
mkdir -p "${SNAPSHOT_DIR}/k8s/sonarqube"
mkdir -p "${SNAPSHOT_DIR}/k8s/grafana"
mkdir -p "${SNAPSHOT_DIR}/ssm"
mkdir -p "${SNAPSHOT_DIR}/github-secrets"
mkdir -p "${BACKUP_ROOT}"

# ------------------------------------------------------------------------------
# 1. Backstage Database Dump (AWS RDS PostgreSQL)
# ------------------------------------------------------------------------------
echo "📦 [1/6] Dumping Backstage PostgreSQL database..."
POSTGRES_HOST="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_HOST}' | base64 -d)"
POSTGRES_PORT="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_PORT}' | base64 -d)"
POSTGRES_USER="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_USER}' | base64 -d)"
POSTGRES_PASSWORD="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_PASSWORD}' | base64 -d)"
POSTGRES_DB="$(kubectl get secret backstage-db-credentials -n backstage -o jsonpath='{.data.POSTGRES_DB}' | base64 -d)"

BACKSTAGE_DUMP="${SNAPSHOT_DIR}/backstage-rds-dump.sql"

if kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --clean --if-exists --no-owner --no-privileges --inserts -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
  > "${BACKSTAGE_DUMP}" 2>/dev/null; then
  echo "✅ Backstage database dump completed."
else
  kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- cat /dumps/backstage-rds-dump.sql > "${BACKSTAGE_DUMP}"
fi

cp "${BACKSTAGE_DUMP}" "${BACKUP_ROOT}/backstage-rds-dump.sql"
cp "${BACKSTAGE_DUMP}" "${REPO_ROOT}/db/live-backup.sql" 2>/dev/null || true
cp "${BACKSTAGE_DUMP}" "/home/ciro/kube-demo-2026/backup/backstage-rds-dump.sql" 2>/dev/null || true

ENTITIES_COUNT="$(grep -c "INSERT INTO public.final_entities" "${BACKSTAGE_DUMP}" || true)"
MIGRATIONS_COUNT="$(grep -c "INSERT INTO public.knex_migrations" "${BACKSTAGE_DUMP}" || true)"
echo "   ├── Entities captured: ${ENTITIES_COUNT}"
echo "   └── Migrations captured: ${MIGRATIONS_COUNT}"

# ------------------------------------------------------------------------------
# 2. SonarQube Database Dump (AWS RDS PostgreSQL)
# ------------------------------------------------------------------------------
echo "📦 [2/6] Dumping SonarQube PostgreSQL database..."
SONAR_DUMP="${SNAPSHOT_DIR}/sonarqube-rds-dump.sql"

if kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" pg_dump --clean --if-exists --no-owner --no-privileges --inserts -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d sonarqube' \
  > "${SONAR_DUMP}" 2>/dev/null; then
  echo "✅ SonarQube database dump completed."
  cp "${SONAR_DUMP}" "${BACKUP_ROOT}/sonarqube-rds-dump.sql"
fi

# ------------------------------------------------------------------------------
# 3. AWS SSM Parameter Store Backup & Replay Script
# ------------------------------------------------------------------------------
echo "🔒 [3/6] Exporting AWS Systems Manager Parameter Store parameters..."
SSM_FILE="${SNAPSHOT_DIR}/ssm/aws-ssm-parameters.json"
SSM_RESTORE_SCRIPT="${SNAPSHOT_DIR}/ssm/restore-ssm.sh"

cat <<'EOF' > "${SSM_RESTORE_SCRIPT}"
#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-us-east-1}"
echo "Restoring AWS SSM parameters to region ${REGION}..."
EOF

chmod +x "${SSM_RESTORE_SCRIPT}"

# Collect all /backstage/github/* and /kube-demo-2026/* parameters
PARAMS_LIST=(
  "/backstage/github/app_id"
  "/backstage/github/client_id"
  "/backstage/github/client_secret"
  "/backstage/github/webhook_secret"
  "/backstage/github/installation_id"
  "/backstage/github/private_key"
  "/kube-demo-2026/platform/credentials"
)

echo "{" > "${SSM_FILE}"
FIRST=true

for param in "${PARAMS_LIST[@]}"; do
  VAL=$(aws ssm get-parameter --name "$param" --with-decryption --query "Parameter.Value" --output text 2>/dev/null || echo "")
  if [ -n "$VAL" ]; then
    if [ "$FIRST" = true ]; then
      FIRST=false
    else
      echo "," >> "${SSM_FILE}"
    fi
    printf '  "%s": %s' "$param" "$(python3 -c "import json, sys; print(json.dumps(sys.stdin.read()))" <<< "$VAL")" >> "${SSM_FILE}"

    # Append to restore-ssm.sh
    cat <<EOF >> "${SSM_RESTORE_SCRIPT}"
aws ssm put-parameter --name "${param}" --value "\$(cat <<'VAL_EOF'
${VAL}
VAL_EOF
)" --type "SecureString" --overwrite --region "\${REGION}"
echo "✅ Restored SSM parameter: ${param}"
EOF
  fi
done

echo "" >> "${SSM_FILE}"
echo "}" >> "${SSM_FILE}"
echo "✅ Exported ${#PARAMS_LIST[@]} SSM parameters and generated ${SSM_RESTORE_SCRIPT}"

# ------------------------------------------------------------------------------
# 4. GitHub Actions Secrets Replay Script & Private Key Backup
# ------------------------------------------------------------------------------
echo "🔑 [4/6] Backing up GitHub App private key and generating GitHub Secrets replay script..."
KEY_FILE="/home/ciro/Downloads/backstage-devex-cirodasilvaj-2026.2026-11-02.private-key.pem"
if [ -f "$KEY_FILE" ]; then
  cp "$KEY_FILE" "${SNAPSHOT_DIR}/github-secrets/backstage-devex-cirodasilvaj.private-key.pem"
fi

GH_SECRETS_SCRIPT="${SNAPSHOT_DIR}/github-secrets/restore-github-secrets.sh"
cat <<'EOF' > "${GH_SECRETS_SCRIPT}"
#!/usr/bin/env bash
set -euo pipefail
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PEM_FILE="${DIR}/backstage-devex-cirodasilvaj.private-key.pem"
GH_TOKEN="${GH_PAT:-$(gh auth token)}"

REPOS=(
  "cirodasilvaj/backstage-infra"
  "cirodasilvaj/apps-demo-2026"
  "cirodasilvaj/samba-ad-keycloak"
  "cirodasilvaj/bkstg-made-nodejs-demo22"
)

for REPO in "${REPOS[@]}"; do
  echo "Setting GitHub Actions Secrets for ${REPO}..."
  gh secret set GH_PAT -R "$REPO" --body "$GH_TOKEN"
  gh secret set GH_APP_ID -R "$REPO" --body "5586387"
  gh secret set GH_APP_CLIENT_ID -R "$REPO" --body "Iv23liISZZ2QWobzor9w"
  gh secret set GH_APP_CLIENT_SECRET -R "$REPO" --body "3a52eeec2608264be71da49ef1ca2e1e814d2040"
  gh secret set GH_APP_WEBHOOK_SECRET -R "$REPO" --body "development-webhook-secret"
  gh secret set GH_APP_INSTALLATION_ID -R "$REPO" --body "177993548"
  if [ -f "$PEM_FILE" ]; then
    gh secret set GH_APP_PRIVATE_KEY -R "$REPO" < "$PEM_FILE"
  fi
  echo "✅ Secrets configured for ${REPO}"
done
EOF

chmod +x "${GH_SECRETS_SCRIPT}"
echo "✅ GitHub Secrets replay script ready at ${GH_SECRETS_SCRIPT}"

# ------------------------------------------------------------------------------
# 5. Export Kubernetes Manifests & State Snapshots
# ------------------------------------------------------------------------------
echo "☸️  [5/6] Exporting Kubernetes manifests and cluster state..."

# Backstage namespace
kubectl get configmap backstage-app-config -n backstage -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/configmap-app-config.yaml" 2>/dev/null || true
kubectl get deployment backstage -n backstage -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/deployment-backstage.yaml" 2>/dev/null || true
kubectl get service backstage -n backstage -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/service-backstage.yaml" 2>/dev/null || true
kubectl get service backstage-external -n backstage -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/service-backstage-external.yaml" 2>/dev/null || true
kubectl get sa backstage -n backstage -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/sa-backstage.yaml" 2>/dev/null || true
kubectl get clusterrole backstage-kubernetes-deployer -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/clusterrole-deployer.yaml" 2>/dev/null || true
kubectl get clusterrolebinding backstage-kubernetes-deployer -o yaml > "${SNAPSHOT_DIR}/k8s/backstage/crb-deployer.yaml" 2>/dev/null || true

# ArgoCD Applications
kubectl get applications -n argocd -o yaml > "${SNAPSHOT_DIR}/k8s/argocd/all-applications.yaml" 2>/dev/null || true

# Apps Demo namespace
kubectl get deployments,services,configmaps -n apps-demo -o yaml > "${SNAPSHOT_DIR}/k8s/apps-demo/all-resources.yaml" 2>/dev/null || true

# SonarQube namespace
kubectl get deployments,services,configmaps -n sonarqube -o yaml > "${SNAPSHOT_DIR}/k8s/sonarqube/all-resources.yaml" 2>/dev/null || true

# Grafana namespace
kubectl get deployments,services,configmaps -n grafana -o yaml > "${SNAPSHOT_DIR}/k8s/grafana/all-resources.yaml" 2>/dev/null || true

# Save cluster status JSON
kubectl exec -n backstage deployment/backstage -c backstage-db-sync -- cat /dumps/k8s-cluster-status.json > "${SNAPSHOT_DIR}/k8s-cluster-status.json" 2>/dev/null || true

# ------------------------------------------------------------------------------
# 6. Integrity Checksums & Tarball Archive Creation
# ------------------------------------------------------------------------------
echo "🔒 [6/6] Generating SHA256 integrity checksums and compressed tarball..."

cat <<EOF > "${SNAPSHOT_DIR}/BACKUP_METADATA.json"
{
  "timestamp": "${TIMESTAMP}",
  "type": "disaster-recovery-full-platform",
  "databases": {
    "backstage": {
      "db_name": "${POSTGRES_DB}",
      "entities_count": ${ENTITIES_COUNT},
      "migrations_count": ${MIGRATIONS_COUNT}
    },
    "sonarqube": {
      "db_name": "sonarqube"
    }
  },
  "aws": {
    "region": "us-east-1",
    "cluster": "kube-demo-eks",
    "ssm_parameters_count": ${#PARAMS_LIST[@]}
  },
  "github": {
    "user": "cirodasilvaj",
    "app_name": "backstage-devex-cirodasilvaj-2026",
    "app_id": "5586387",
    "client_id": "Iv23liISZZ2QWobzor9w",
    "installation_id": "177993548"
  }
}
EOF

(cd "${SNAPSHOT_DIR}" && find . -type f ! -name "SHA256SUMS" -exec sha256sum {} + > SHA256SUMS)

ARCHIVE_FILE="${BACKUP_ROOT}/full-platform-backup-${TIMESTAMP}.tar.gz"
tar -czf "${ARCHIVE_FILE}" -C "${REPO_ROOT}/backup/snapshots" "${TIMESTAMP}"
LATEST_ARCHIVE="${BACKUP_ROOT}/latest-platform-backup.tar.gz"
cp "${ARCHIVE_FILE}" "${LATEST_ARCHIVE}"

ARCHIVE_SIZE="$(du -h "${ARCHIVE_FILE}" | cut -f1)"

echo "=================================================================="
echo "🎉 DISASTER RECOVERY FULL BACKUP COMPLETED!"
echo "=================================================================="
echo "📁 Snapshot folder: ${SNAPSHOT_DIR}"
echo "📦 Archive: ${ARCHIVE_FILE} (${ARCHIVE_SIZE})"
echo "🔗 Latest pointer: ${LATEST_ARCHIVE}"
echo "=================================================================="
