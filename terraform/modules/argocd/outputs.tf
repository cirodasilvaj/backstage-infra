output "namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "release_name" {
  description = "Helm release name for ArgoCD"
  value       = helm_release.argocd.name
}

output "release_status" {
  description = "Helm release status for ArgoCD"
  value       = helm_release.argocd.status
}

output "chart_version" {
  description = "Installed ArgoCD Helm chart version"
  value       = helm_release.argocd.version
}

output "service_url" {
  description = "Internal cluster URL for ArgoCD server"
  value       = "http://argocd-server.${kubernetes_namespace.argocd.metadata[0].name}.svc.cluster.local"
}
