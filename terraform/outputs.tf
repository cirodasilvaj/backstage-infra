output "argocd_namespace" {
  description = "Namespace where ArgoCD was installed"
  value       = module.argocd.namespace
}

output "argocd_get_admin_password_command" {
  description = "Run this after apply to retrieve the ArgoCD initial admin password"
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_port_forward_command" {
  description = "Run this to reach the ArgoCD UI at https://localhost:8080"
  value       = "kubectl -n ${var.argocd_namespace} port-forward svc/argocd-server 8080:443"
}

output "backstage_port_forward_command" {
  description = "Run this to reach the Backstage UI at http://localhost:7007 once ArgoCD has synced it"
  value       = "kubectl -n ${var.backstage_namespace} port-forward svc/backstage 7007:7007"
}
