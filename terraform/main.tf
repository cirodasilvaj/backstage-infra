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

  argocd_namespace   = var.argocd_namespace
  app_namespace      = var.backstage_namespace
  repo_url           = var.backstage_repo_url
  repo_path          = var.backstage_repo_path
  target_revision    = var.backstage_target_revision

  depends_on = [module.argocd]
}
