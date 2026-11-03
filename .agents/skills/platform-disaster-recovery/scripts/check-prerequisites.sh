#!/usr/bin/env bash
# ==============================================================================
# Script: check-prerequisites.sh
# Purpose: Pre-flight checks before restoring the Backstage & EKS platform
# ==============================================================================
set -euo pipefail

echo "=================================================================="
echo "🔍 PRE-FLIGHT VERIFICATION: PLATFORM DISASTER RECOVERY"
echo "=================================================================="

ERRORS=0

# 1. AWS Credentials
echo -n "1. Checking AWS CLI authentication... "
if ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text 2>/dev/null); then
  USER_ARN=$(aws sts get-caller-identity --query Arn --output text 2>/dev/null)
  REGION="${AWS_REGION:-$(aws configure get region || echo "us-east-1")}"
  echo "✅ OK (Account: ${ACCOUNT_ID}, Region: ${REGION}, Arn: ${USER_ARN})"
else
  echo "❌ FAILED"
  echo "   ⚠️ AWS credentials are not configured or expired. Run 'aws configure' or set AWS_ACCESS_KEY_ID."
  ERRORS=$((ERRORS + 1))
fi

# 2. GitHub CLI Credentials
echo -n "2. Checking GitHub CLI authentication... "
if GH_USER=$(gh api user --jq .login 2>/dev/null); then
  echo "✅ OK (Logged in as: ${GH_USER})"
else
  echo "❌ FAILED"
  echo "   ⚠️ GitHub CLI is not authenticated. Run 'gh auth login' or export GH_TOKEN."
  ERRORS=$((ERRORS + 1))
fi

# 3. Required CLI Tools
echo -n "3. Checking required command-line tools... "
MISSING_TOOLS=()
for tool in terraform kubectl tar jq curl sha256sum; do
  if ! command -v "$tool" >/dev/null 2>&1; then
    MISSING_TOOLS+=("$tool")
  fi
done

if [ ${#MISSING_TOOLS[@]} -eq 0 ]; then
  echo "✅ OK (terraform, kubectl, tar, jq, curl, sha256sum found)"
else
  echo "❌ FAILED (Missing: ${MISSING_TOOLS[*]})"
  ERRORS=$((ERRORS + 1))
fi

# 4. Backup Tarball Presence
echo -n "4. Checking platform disaster recovery backup tarball... "
BACKUP_TAR="/home/ciro/backstate-infra/backup/latest-platform-backup.tar.gz"
if [ ! -f "$BACKUP_TAR" ]; then
  BACKUP_TAR="/home/ciro/.gemini/antigravity-cli/brain/98852110-6920-422f-889b-23624c5bcf53/latest-platform-backup.tar.gz"
fi

if [ -f "$BACKUP_TAR" ]; then
  SIZE=$(du -h "$BACKUP_TAR" | cut -f1)
  echo "✅ OK (${BACKUP_TAR} - ${SIZE})"
else
  echo "❌ FAILED (Backup archive not found)"
  ERRORS=$((ERRORS + 1))
fi

echo "=================================================================="
if [ "$ERRORS" -eq 0 ]; then
  echo "🎉 ALL PREREQUISITES PASSED! System is ready for automated restore."
  exit 0
else
  echo "❌ FAILED: ${ERRORS} check(s) did not pass. Please fix the issues above before restoring."
  exit 1
fi
