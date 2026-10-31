output "namespace" {
  description = "Namespace where Fluentd is installed"
  value       = kubernetes_namespace.logging.metadata[0].name
}

output "release_name" {
  description = "Helm release name for Fluentd"
  value       = helm_release.fluentd.name
}

output "release_status" {
  description = "Helm release status for Fluentd"
  value       = helm_release.fluentd.status
}

output "chart_version" {
  description = "Installed Fluentd Helm chart version"
  value       = helm_release.fluentd.version
}
