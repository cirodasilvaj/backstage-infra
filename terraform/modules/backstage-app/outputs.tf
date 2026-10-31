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

output "external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to Backstage"
  value       = try(kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "external_url" {
  description = "External HTTP URL (port 80) for the Backstage UI"
  value       = try("http://${kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname}", "")
}

output "external_url_7007" {
  description = "External HTTP URL (port 7007) for the Backstage UI"
  value       = try("http://${kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname}:7007", "")
}

output "basic_auth_user" {
  description = "Basic authentication username for the Backstage web UI"
  value       = var.auth_user
}

output "basic_auth_password" {
  description = "Basic authentication password for the Backstage web UI"
  value       = var.auth_password
}

output "db_dump_download_url" {
  description = "Direct web URL to download the live RDS PostgreSQL dump (.sql)"
  value       = try("http://${kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname}/backstage-rds-dump.sql", "")
}

output "db_schema_download_url" {
  description = "Direct web URL to download the base PostgreSQL schema (.sql)"
  value       = try("http://${kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname}/backstage-schema.sql", "")
}

output "k8s_cluster_status_url" {
  description = "Direct web URL to inspect the live Kubernetes cluster integration status JSON"
  value       = try("http://${kubernetes_service_v1.backstage_external.status[0].load_balancer[0].ingress[0].hostname}/k8s-cluster-status.json", "")
}

output "k8s_service_account" {
  description = "Kubernetes ServiceAccount used by Backstage to query the EKS cluster"
  value       = "backstage"
}

output "k8s_cluster_role" {
  description = "Kubernetes ClusterRole granting Backstage read access to cluster resources"
  value       = "backstage-kubernetes-reader"
}

