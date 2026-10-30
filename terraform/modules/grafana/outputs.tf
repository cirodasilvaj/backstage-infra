output "namespace" {
  value = kubernetes_namespace.grafana.metadata[0].name
}
