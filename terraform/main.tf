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

  db_host     = module.rds.address
  db_port     = tostring(module.rds.port)
  db_name     = module.rds.db_name
  db_username = module.rds.username
  db_password = var.rds_db_password

  depends_on = [module.argocd, module.rds]
}

# 4. Grafana, wired to the Prometheus server already installed by
#    kube-demo-2026/eks (release "prometheus", namespace "monitoring").
module "grafana" {
  source = "./modules/grafana"

  namespace            = var.grafana_namespace
  chart_version        = var.grafana_chart_version
  prometheus_namespace = var.prometheus_namespace
}

# 5. Fluentd, shipping container logs cluster-wide.
module "fluentd" {
  source = "./modules/fluentd"

  namespace     = var.fluentd_namespace
  chart_version = var.fluentd_chart_version
}
