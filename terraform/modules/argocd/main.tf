resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.namespace
  }
}

resource "helm_release" "argocd" {
  name            = "argocd"
  repository      = "https://argoproj.github.io/argo-helm"
  chart           = "argo-cd"
  version         = var.chart_version
  namespace       = kubernetes_namespace.argocd.metadata[0].name
  wait            = false
  cleanup_on_fail = true
  force_update    = true

  set {
    name  = "crds.install"
    value = "false"
  }

  # ClusterIP + kubectl port-forward for the demo; swap for a LoadBalancer
  # or Ingress once the cluster has one configured.
  set {
    name  = "server.service.type"
    value = "ClusterIP"
  }

  set {
    name  = "configs.params.server\\.insecure"
    value = "true"
  }
}

# Prometheus scrape Service for ArgoCD metrics (controller :8082 & server :8083)
resource "kubernetes_service_v1" "argocd_metrics" {
  metadata {
    name      = "argocd-prometheus-metrics"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "app.kubernetes.io/name"    = "argocd-metrics"
      "app.kubernetes.io/part-of" = "argocd"
    }
    annotations = {
      "prometheus.io/scrape" = "true"
      "prometheus.io/port"   = "8082"
      "prometheus.io/path"   = "/metrics"
    }
  }

  spec {
    type = "ClusterIP"

    selector = {
      "app.kubernetes.io/name" = "argocd-application-controller"
    }

    port {
      name        = "metrics"
      port        = 8082
      target_port = 8082
      protocol    = "TCP"
    }
  }

  depends_on = [helm_release.argocd]
}

# External LoadBalancer service for demo access to the ArgoCD Web UI.
resource "kubernetes_service_v1" "argocd_external" {
  metadata {
    name      = "argocd-external"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = "argocd-server"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      "app.kubernetes.io/name" = "argocd-server"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 8080
      protocol    = "TCP"
    }

    port {
      name        = "argocd-8080"
      port        = 8080
      target_port = 8080
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = true

  depends_on = [helm_release.argocd]
}
