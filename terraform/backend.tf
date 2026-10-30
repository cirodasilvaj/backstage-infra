# Backend config is supplied at `terraform init` time (see
# .github/workflows/terraform.yml and the README), not hardcoded here, so
# the same code works for CI and for a local run against a different
# bucket/account.
terraform {
  backend "s3" {}
}
