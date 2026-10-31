resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/part-of" = "observability"
    }
  }
}

resource "helm_release" "grafana" {
  name            = "grafana"
  repository      = "https://grafana.github.io/helm-charts"
  chart           = "grafana"
  version         = var.chart_version
  namespace       = kubernetes_namespace.grafana.metadata[0].name
  wait            = false
  cleanup_on_fail = true
  force_update    = true

  set {
    name  = "service.type"
    value = "ClusterIP"
  }

  set {
    name  = "adminUser"
    value = var.admin_user
  }

  set {
    name  = "adminPassword"
    value = var.admin_password
  }

  set {
    name  = "persistence.enabled"
    value = "false"
  }

  # Points at the prometheus-community/prometheus server installed by
  # kube-demo-2026/eks (release "prometheus", namespace "monitoring").
  set {
    name  = "datasources.datasources\\.yaml.apiVersion"
    value = "1"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].name"
    value = "Prometheus"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].type"
    value = "prometheus"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].url"
    value = "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].access"
    value = "proxy"
  }
  set {
    name  = "datasources.datasources\\.yaml.datasources[0].isDefault"
    value = "true"
  }
}

# Register the dedicated k8s-manifests/grafana directory in ArgoCD
resource "kubernetes_manifest" "grafana_application" {
  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "Application"
    metadata = {
      name      = "grafana-metrics"
      namespace = var.argocd_namespace
      finalizers = [
        "resources-finalizer.argocd.argoproj.io",
      ]
    }
    spec = {
      project = "default"
      source = {
        repoURL        = var.repo_url
        targetRevision = var.target_revision
        path           = var.repo_path
      }
      destination = {
        server    = "https://kubernetes.default.svc"
        namespace = kubernetes_namespace.grafana.metadata[0].name
      }
      syncPolicy = {
        automated = {
          prune    = true
          selfHeal = true
        }
        syncOptions = [
          "CreateNamespace=true",
        ]
      }
    }
  }
}

# External AWS LoadBalancer Service for Grafana UI (ports 80 and 3000)
resource "kubernetes_service" "grafana_external" {
  metadata {
    name      = "grafana-external"
    namespace = kubernetes_namespace.grafana.metadata[0].name
    labels = {
      "app.kubernetes.io/name" = "grafana"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      "app.kubernetes.io/name" = "grafana"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 3000
      protocol    = "TCP"
    }

    port {
      name        = "grafana-3000"
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = true
}
