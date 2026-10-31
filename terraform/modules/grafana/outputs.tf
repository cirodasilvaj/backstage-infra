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
  value       = "http://grafana.${kubernetes_namespace.grafana.metadata[0].name}.svc.cluster.local"
}

output "prometheus_datasource_url" {
  description = "Prometheus datasource URL configured in Grafana"
  value       = "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local"
}
