# 1. Install ArgoCD on the existing EKS cluster via Helm.
module "argocd" {
  source = "./modules/argocd"

  namespace     = var.argocd_namespace
  chart_version = var.argocd_chart_version
}

# 2. Provision the cheapest possible AWS RDS PostgreSQL instance (db.t4g.micro)
#    inside the EKS cluster VPC for Backstage persistence.
module "rds" {
  source = "./modules/rds"

  vpc_id                    = data.aws_eks_cluster.target.vpc_config[0].vpc_id
  subnet_ids                = data.aws_eks_cluster.target.vpc_config[0].subnet_ids
  vpc_cidr_block            = data.aws_vpc.target.cidr_block
  cluster_security_group_id = data.aws_eks_cluster.target.vpc_config[0].cluster_security_group_id

  db_identifier  = var.rds_db_identifier
  instance_class = var.rds_instance_class
  db_name        = var.rds_db_name
  db_username    = var.rds_db_username
  db_password    = var.rds_db_password
}

# GitHub App credentials from AWS SSM Parameter Store
data "aws_ssm_parameter" "github_app_id" {
  name            = "/backstage/github/app_id"
  with_decryption = true
}

data "aws_ssm_parameter" "github_client_id" {
  name            = "/backstage/github/client_id"
  with_decryption = true
}

data "aws_ssm_parameter" "github_client_secret" {
  name            = "/backstage/github/client_secret"
  with_decryption = true
}

data "aws_ssm_parameter" "github_private_key" {
  name            = "/backstage/github/private_key"
  with_decryption = true
}

# 3. Register Backstage as an ArgoCD Application so ArgoCD takes over
#    deploying/syncing it from k8s-manifests/backstage in this same repo.
module "backstage_app" {
  source = "./modules/backstage-app"

  argocd_namespace = var.argocd_namespace
  app_namespace    = var.backstage_namespace
  repo_url         = var.backstage_repo_url
  repo_path        = var.backstage_repo_path
  target_revision  = var.backstage_target_revision
  auth_user        = var.backstage_auth_user
  auth_password    = var.backstage_auth_password

  db_host      = module.rds.address
  db_port      = tostring(module.rds.port)
  db_name      = module.rds.db_name
  db_username  = module.rds.username
  db_password  = var.rds_db_password
  cluster_name = var.eks_cluster_name

  github_token             = var.github_token
  github_app_id            = data.aws_ssm_parameter.github_app_id.value
  github_app_client_id     = data.aws_ssm_parameter.github_client_id.value
  github_app_client_secret = data.aws_ssm_parameter.github_client_secret.value
  github_app_private_key   = data.aws_ssm_parameter.github_private_key.value
  acm_certificate_arn      = local.has_lab_zone ? aws_acm_certificate_validation.lab_cert[0].certificate_arn : ""

  depends_on = [module.argocd, module.rds]
}

# 4. Grafana, wired to the Prometheus server already installed by
#    kube-demo-2026/eks (release "prometheus", namespace "monitoring").
module "grafana" {
  source = "./modules/grafana"

  namespace            = var.grafana_namespace
  chart_version        = var.grafana_chart_version
  prometheus_namespace = var.prometheus_namespace
  argocd_namespace     = var.argocd_namespace
  repo_url             = var.backstage_repo_url
  repo_path            = "k8s-manifests/grafana"
  target_revision      = var.backstage_target_revision

  depends_on = [module.argocd]
}

# 5. Fluentd, shipping container logs cluster-wide.
module "fluentd" {
  source = "./modules/fluentd"

  namespace     = var.fluentd_namespace
  chart_version = var.fluentd_chart_version
}

# 6. SonarQube QA & Security Scanner (with OWASP Dependency-Check, FindSecBugs & YAML/K8s plugins),
#    persisted on AWS RDS PostgreSQL and exposed via AWS LoadBalancer.
module "sonarqube" {
  source = "./modules/sonarqube"

  argocd_namespace = var.argocd_namespace
  app_namespace    = var.sonarqube_namespace
  repo_url         = var.backstage_repo_url
  repo_path        = "k8s-manifests/sonarqube"
  target_revision  = var.backstage_target_revision

  admin_user     = var.sonarqube_admin_user
  admin_password = var.sonarqube_admin_password

  db_host     = module.rds.address
  db_port     = tostring(module.rds.port)
  db_username = module.rds.username
  db_password = var.rds_db_password

  depends_on = [module.argocd, module.rds]
}

