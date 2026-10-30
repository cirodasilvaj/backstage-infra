resource "kubernetes_namespace" "logging" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "fluentd" {
  name       = "fluentd"
  repository = "https://fluent.github.io/helm-charts"
  chart      = "fluentd"
  version    = var.chart_version
  namespace  = kubernetes_namespace.logging.metadata[0].name

  # Demo wiring: ship container logs to stdout only (no external log store
  # configured). Swap in a real `output.conf` (Elasticsearch, S3, etc.) via
  # `fileConfigs` once a destination is chosen.
  set {
    name  = "variant"
    value = "fluentd"
  }
}
