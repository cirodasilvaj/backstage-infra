output "namespace" {
  value = kubernetes_namespace.logging.metadata[0].name
}
