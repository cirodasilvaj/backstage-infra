# 1. Install ArgoCD on the existing EKS cluster via Helm.
module "argocd" {
  source = "./modules/argocd"

  namespace     = var.argocd_namespace
  chart_version = var.argocd_chart_version
}

# 2. Register Backstage as an ArgoCD Application so ArgoCD takes over
#    deploying/syncing it from k8s-manifests/backstage in this same repo.
module "backstage_app" {
  source = "./modules/backstage-app"

  argocd_namespace = var.argocd_namespace
  app_namespace    = var.backstage_namespace
  repo_url         = var.backstage_repo_url
  repo_path        = var.backstage_repo_path
  target_revision  = var.backstage_target_revision

  depends_on = [module.argocd]
}

# 3. Register kube-prometheus-stack (Prometheus/Alertmanager/Grafana) as an
#    ArgoCD Application so the cluster has standard observability instead
#    of none at all.
module "monitoring_app" {
  source = "./modules/monitoring-app"

  argocd_namespace = var.argocd_namespace
  app_namespace    = var.monitoring_namespace
  chart_version    = var.monitoring_chart_version

  depends_on = [module.argocd]
}

# 4. Register Fluentd as an ArgoCD Application, shipping container logs to
#    CloudWatch Logs via the IRSA role created in kube-demo-2026/eks. Log
#    aggregation didn't exist anywhere before this.
module "logging_app" {
  source = "./modules/logging-app"

  argocd_namespace = var.argocd_namespace
  app_namespace    = var.logging_namespace
  chart_version    = var.logging_chart_version
  fluentd_role_arn = data.aws_iam_role.fluentd.arn
  aws_region       = var.aws_region
  cluster_name     = var.eks_cluster_name

  depends_on = [module.argocd]
}
