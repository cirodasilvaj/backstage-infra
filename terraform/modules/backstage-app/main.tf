# The Application manifest lives in k8s-manifests/argo so it stays reviewable
# as plain YAML; Terraform just applies it and fills in the per-environment
# values (namespace, repo, path, branch).
resource "kubernetes_manifest" "backstage_application" {
  manifest = yamldecode(templatefile("${path.module}/../../../k8s-manifests/argo/application-backstage.yaml", {
    argocd_namespace = var.argocd_namespace
    app_namespace    = var.app_namespace
    repo_url         = var.repo_url
    repo_path        = var.repo_path
    target_revision  = var.target_revision
  }))
}
