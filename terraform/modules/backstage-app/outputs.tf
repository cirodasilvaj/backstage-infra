output "application_name" {
  description = "Name of the ArgoCD Application managing Backstage"
  value       = kubernetes_manifest.backstage_application.manifest.metadata.name
}

output "argocd_namespace" {
  description = "Namespace where the ArgoCD Application CR is registered"
  value       = var.argocd_namespace
}

output "app_namespace" {
  description = "Target namespace where Backstage is deployed"
  value       = var.app_namespace
}

output "repo_url" {
  description = "Git repository URL watched by ArgoCD for Backstage"
  value       = var.repo_url
}

output "repo_path" {
  description = "Path inside the repository watched by ArgoCD"
  value       = var.repo_path
}

output "target_revision" {
  description = "Git branch/revision tracked by ArgoCD"
  value       = var.target_revision
}

output "service_url" {
  description = "Internal cluster URL for Backstage service"
  value       = "http://backstage.${var.app_namespace}.svc.cluster.local:7007"
}
