#!/usr/bin/env bash
# ==============================================================================
# Script: full-restore.sh
# Purpose: Master automation script to restore the entire platform from zero
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=================================================================="
echo "🚀 STARTING COMPLETE PLATFORM DISASTER RECOVERY & RESTORE"
echo "=================================================================="

# 1. Run Pre-flight Checks
"${SCRIPT_DIR}/check-prerequisites.sh"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
REGION="${AWS_REGION:-us-east-1}"
echo "🏢 Target AWS Account: ${ACCOUNT_ID} (${REGION})"

# 2. Phase 1: Sync GitHub Secrets to AWS SSM Parameter Store
echo ""
echo "=================================================================="
echo "🔒 [PHASE 1] Sychronizing GitHub Secrets to AWS Parameter Store..."
echo "=================================================================="
PEM_FILE="/home/ciro/Downloads/backstage-devex-cirodasilvaj-2026.2026-11-02.private-key.pem"
if [ ! -f "$PEM_FILE" ]; then
  for pf in \
    "/home/ciro/platform-backup-vault/snapshots"/*/secrets/github-app/backstage-devex.private-key.pem \
    "$HOME/platform-backup-vault/snapshots"/*/secrets/github-app/backstage-devex.private-key.pem \
    "/home/ciro/backstate-infra/backup/snapshots"/*/github-secrets/backstage-devex-cirodasilvaj.private-key.pem; do
    if [ -f "$pf" ]; then
      PEM_FILE="$pf"
      break
    fi
  done
fi

# Load GitHub App Client Secret from environment or off-repo vault
if [ -z "${GITHUB_APP_CLIENT_SECRET:-}" ]; then
  for vf in \
    "/home/ciro/platform-backup-vault/snapshots"/*/secrets/github-app/github-app-credentials.env \
    "$HOME/platform-backup-vault/snapshots"/*/secrets/github-app/github-app-credentials.env; do
    if [ -f "$vf" ]; then
      GITHUB_APP_CLIENT_SECRET="$(grep -E '^GITHUB_APP_CLIENT_SECRET=' "$vf" | head -n1 | cut -d= -f2-)"
      [ -n "$GITHUB_APP_CLIENT_SECRET" ] && break
    fi
  done
fi

aws ssm put-parameter --name "/backstage/github/app_id" --value "5586387" --type "SecureString" --overwrite --region "$REGION" || true
aws ssm put-parameter --name "/backstage/github/client_id" --value "Iv23liISZZ2QWobzor9w" --type "SecureString" --overwrite --region "$REGION" || true
if [ -n "${GITHUB_APP_CLIENT_SECRET:-}" ]; then
  aws ssm put-parameter --name "/backstage/github/client_secret" --value "$GITHUB_APP_CLIENT_SECRET" --type "SecureString" --overwrite --region "$REGION" || true
fi
aws ssm put-parameter --name "/backstage/github/webhook_secret" --value "development-webhook-secret" --type "SecureString" --overwrite --region "$REGION" || true
aws ssm put-parameter --name "/backstage/github/installation_id" --value "177993548" --type "SecureString" --overwrite --region "$REGION" || true
if [ -f "$PEM_FILE" ]; then
  aws ssm put-parameter --name "/backstage/github/private_key" --value file://"${PEM_FILE}" --type "SecureString" --overwrite --region "$REGION" || true
fi
echo "✅ AWS Parameter Store credentials populated."

# 3. Phase 2: Check or Provision EKS Cluster
echo ""
echo "=================================================================="
echo "☸️  [PHASE 2] Ensuring EKS Cluster (kube-demo-eks)..."
echo "=================================================================="
if aws eks describe-cluster --name "kube-demo-eks" --region "$REGION" >/dev/null 2>&1; then
  echo "✅ EKS Cluster 'kube-demo-eks' already exists and is active."
else
  echo "🚀 Provisioning EKS Cluster via Terraform (kube-demo-2026/eks)..."
  
  EKS_BUCKET="kube-demo-2026-tfstate-${ACCOUNT_ID}"
  EKS_LOCK_TABLE="kube-demo-2026-tfstate-lock-${ACCOUNT_ID}"
  
  if ! aws s3api head-bucket --bucket "$EKS_BUCKET" 2>/dev/null; then
    echo "Creating EKS S3 state bucket: ${EKS_BUCKET}..."
    if [ "$REGION" = "us-east-1" ]; then
      aws s3api create-bucket --bucket "$EKS_BUCKET"
    else
      aws s3api create-bucket --bucket "$EKS_BUCKET" --create-bucket-configuration LocationConstraint="${REGION}"
    fi
    aws s3api put-bucket-versioning --bucket "$EKS_BUCKET" --versioning-configuration Status=Enabled
    aws s3api put-public-access-block --bucket "$EKS_BUCKET" --public-access-block-configuration BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true
  fi

  if ! aws dynamodb describe-table --table-name "$EKS_LOCK_TABLE" >/dev/null 2>&1; then
    echo "Creating EKS DynamoDB lock table: ${EKS_LOCK_TABLE}..."
    aws dynamodb create-table \
      --table-name "$EKS_LOCK_TABLE" \
      --attribute-definitions AttributeName=LockID,AttributeType=S \
      --key-schema AttributeName=LockID,KeyType=HASH \
      --billing-mode PAY_PER_REQUEST
    aws dynamodb wait table-exists --table-name "$EKS_LOCK_TABLE"
  fi

  cd /home/ciro/kube-demo-2026/eks
  terraform init -input=false -reconfigure \
    -backend-config="bucket=${EKS_BUCKET}" \
    -backend-config="key=eks/terraform.tfstate" \
    -backend-config="region=${REGION}" \
    -backend-config="dynamodb_table=${EKS_LOCK_TABLE}"
  terraform apply -input=false -auto-approve
fi

aws eks update-kubeconfig --name "kube-demo-eks" --region "$REGION"
echo "✅ Kubernetes context updated for kube-demo-eks."

# 4. Phase 3: Deploy Platform (RDS, Backstage, SonarQube, Grafana, ArgoCD)
echo ""
echo "=================================================================="
echo "📦 [PHASE 3] Deploying Backstage Platform & Workloads..."
echo "=================================================================="
cd /home/ciro/backstate-infra/terraform

STATE_BUCKET="backstage-infra-tfstate-${ACCOUNT_ID}"
LOCK_TABLE="backstage-infra-tfstate-lock-${ACCOUNT_ID}"

if ! aws s3api head-bucket --bucket "$STATE_BUCKET" 2>/dev/null; then
  echo "Creating S3 backend bucket: ${STATE_BUCKET}..."
  if [ "$REGION" = "us-east-1" ]; then
    aws s3api create-bucket --bucket "$STATE_BUCKET"
  else
    aws s3api create-bucket --bucket "$STATE_BUCKET" --create-bucket-configuration LocationConstraint="${REGION}"
  fi
  aws s3api put-bucket-versioning --bucket "$STATE_BUCKET" --versioning-configuration Status=Enabled
fi

if ! aws dynamodb describe-table --table-name "$LOCK_TABLE" >/dev/null 2>&1; then
  echo "Creating DynamoDB lock table: ${LOCK_TABLE}..."
  aws dynamodb create-table \
    --table-name "$LOCK_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --billing-mode PAY_PER_REQUEST
  aws dynamodb wait table-exists --table-name "$LOCK_TABLE"
fi

terraform init -input=false -reconfigure \
  -backend-config="bucket=${STATE_BUCKET}" \
  -backend-config="key=backstage-infra/terraform.tfstate" \
  -backend-config="region=${REGION}" \
  -backend-config="dynamodb_table=${LOCK_TABLE}"

# Pre-install ArgoCD CRDs and namespaces
kubectl apply -k https://github.com/argoproj/argo-cd/manifests/crds\?ref=v2.12.3 2>/dev/null || true
kubectl create namespace backstage --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace sonarqube --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace apps-demo --dry-run=client -o yaml | kubectl apply -f -

export TF_VAR_rds_db_password="BackstageRds2026!"
export TF_VAR_backstage_admin_password="Backstage@2026"
export TF_VAR_sonarqube_admin_password="Sonar@2026"

terraform apply -input=false -auto-approve

# Install Argo Rollouts for Canary deployment support
kubectl create namespace argo-rollouts --dry-run=client -o yaml | kubectl apply -f -
kubectl apply --server-side -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml || true

# Apply Backstage and Argo manifests
kubectl apply -f ../k8s-manifests/backstage/

# 5. Phase 4: Database Snapshot Restore
echo ""
echo "=================================================================="
echo "🗄️  [PHASE 4] Restoring Databases from Backup Snapshot..."
echo "=================================================================="
BACKUP_TAR="/home/ciro/backstate-infra/backup/latest-platform-backup.tar.gz"
if [ ! -f "$BACKUP_TAR" ]; then
  BACKUP_TAR="/home/ciro/.gemini/antigravity-cli/brain/98852110-6920-422f-889b-23624c5bcf53/latest-platform-backup.tar.gz"
fi

if [ -f "$BACKUP_TAR" ]; then
  echo "Running /home/ciro/backstate-infra/scripts/restore-full-platform.sh..."
  /home/ciro/backstate-infra/scripts/restore-full-platform.sh "$BACKUP_TAR" || true
fi

# 6. Phase 5: Route 53 DNS & SSL
echo ""
echo "=================================================================="
echo "🌐 [PHASE 5] Synchronizing Route 53 DNS and ACM Certificates..."
echo "=================================================================="
/home/ciro/backstate-infra/scripts/sync-dns-route53.sh || true

# 7. Phase 6: Verification & Health Check
echo ""
echo "=================================================================="
echo "🩺 [PHASE 6] Running Verification & Health Suite..."
echo "=================================================================="
"${SCRIPT_DIR}/verify-health.sh"

echo "=================================================================="
echo "🎉 FULL PLATFORM DISASTER RECOVERY RESTORE COMPLETE!"
echo "=================================================================="
