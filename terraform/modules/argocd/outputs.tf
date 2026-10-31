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

output "external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to ArgoCD"
  value       = try(kubernetes_service_v1.argocd_external.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "external_url" {
  description = "External HTTP URL (port 80) for the ArgoCD Web UI"
  value       = try("http://${kubernetes_service_v1.argocd_external.status[0].load_balancer[0].ingress[0].hostname}", "")
}

output "external_url_8080" {
  description = "External HTTP URL (port 8080) for the ArgoCD Web UI"
  value       = try("http://${kubernetes_service_v1.argocd_external.status[0].load_balancer[0].ingress[0].hostname}:8080", "")
}

