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

  # Enable ArgoCD Prometheus metrics for controller, server and repo-server
  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }
  set {
    name  = "controller.metrics.service.annotations.prometheus\\.io/scrape"
    value = "true"
  }
  set {
    name  = "controller.metrics.service.annotations.prometheus\\.io/port"
    value = "8082"
  }
  set {
    name  = "server.metrics.enabled"
    value = "true"
  }
  set {
    name  = "server.metrics.service.annotations.prometheus\\.io/scrape"
    value = "true"
  }
  set {
    name  = "server.metrics.service.annotations.prometheus\\.io/port"
    value = "8083"
  }
  set {
    name  = "repoServer.metrics.enabled"
    value = "true"
  }
  set {
    name  = "repoServer.metrics.service.annotations.prometheus\\.io/scrape"
    value = "true"
  }
  set {
    name  = "repoServer.metrics.service.annotations.prometheus\\.io/port"
    value = "8084"
  }
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

