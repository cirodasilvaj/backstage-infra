output "namespace" {
  description = "Namespace where Grafana is installed"
  value       = kubernetes_namespace.grafana.metadata[0].name
}

output "release_name" {
  description = "Helm release name for Grafana"
  value       = helm_release.grafana.name
}

output "release_status" {
  description = "Helm release status for Grafana"
  value       = helm_release.grafana.status
}

output "chart_version" {
  description = "Installed Grafana Helm chart version"
  value       = helm_release.grafana.version
}

output "service_url" {
  description = "Internal cluster URL for Grafana"
  value       = "http://grafana-metrics.${kubernetes_namespace.grafana.metadata[0].name}.svc.cluster.local"
}

output "prometheus_datasource_url" {
  description = "Prometheus datasource URL configured in Grafana"
  value       = "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local"
}

output "external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to Grafana"
  value       = try(kubernetes_service.grafana_external.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "external_url" {
  description = "Public HTTP URL (port 80) to access the Grafana UI"
  value       = try("http://${kubernetes_service.grafana_external.status[0].load_balancer[0].ingress[0].hostname}", "")
}

output "external_url_3000" {
  description = "Public HTTP URL (port 3000) to access the Grafana UI"
  value       = try("http://${kubernetes_service.grafana_external.status[0].load_balancer[0].ingress[0].hostname}:3000", "")
}

output "admin_user" {
  description = "Admin username for the Grafana Web UI"
  value       = var.admin_user
}

output "admin_password" {
  description = "Admin password for the Grafana Web UI"
  value       = var.admin_password
}
