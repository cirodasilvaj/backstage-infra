resource "kubernetes_namespace" "grafana" {
  metadata {
    name = var.namespace
    labels = {
      "app.kubernetes.io/part-of" = "observability"
    }
  }
}

locals {
  dashboard_apps = jsonencode({
    title         = "1. Apps Demo - Prometheus Metrics & Fluentd/Loki Logs"
    uid           = "apps-prometheus-loki"
    timezone      = "browser"
    schemaVersion = 39
    version       = 1
    refresh       = "15s"
    panels = [
      {
        id         = 1
        title      = "App HTTP Requests Total (Prometheus /metrics)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 0, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (app, language, endpoint) (app_http_requests_total)"
            legendFormat = "{{app}} ({{language}}) {{endpoint}}"
          }
        ]
      },
      {
        id         = 2
        title      = "Apps Demo Pods CPU Usage (Prometheus)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 8, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (pod) (rate(container_cpu_usage_seconds_total{namespace=\"apps-demo\",container!=\"\"}[5m]))"
            legendFormat = "{{pod}}"
          }
        ]
      },
      {
        id         = 3
        title      = "Apps Demo Pods Memory Usage (Prometheus)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 16, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (pod) (container_memory_working_set_bytes{namespace=\"apps-demo\",container!=\"\"})"
            legendFormat = "{{pod}}"
          }
        ]
      },
      {
        id         = 4
        title      = "Apps Demo Live Logs (Shipped by Fluentd -> Loki)"
        type       = "logs"
        gridPos    = { h = 10, w = 24, x = 0, y = 7 }
        datasource = { type = "loki", uid = "loki-eks" }
        options = {
          showTime         = true
          showLabels       = true
          wrapLogMessage   = true
          enableLogDetails = true
          sortOrder        = "Descending"
        }
        targets = [
          {
            expr = "{namespace=\"apps-demo\"}"
          }
        ]
      }
    ]
  })

  dashboard_argocd = jsonencode({
    title         = "2. ArgoCD GitOps - Prometheus Metrics & Fluentd/Loki Logs"
    uid           = "argocd-prometheus-loki"
    timezone      = "browser"
    schemaVersion = 39
    version       = 1
    refresh       = "15s"
    panels = [
      {
        id         = 1
        title      = "ArgoCD Applications Sync & Health Info (Prometheus)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 0, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (name, health_status, sync_status) (argocd_app_info)"
            legendFormat = "{{name}} ({{sync_status}} / {{health_status}})"
          },
          {
            expr         = "count by (pod) (kube_pod_info{namespace=\"argocd\"})"
            legendFormat = "pod: {{pod}}"
          }
        ]
      },
      {
        id         = 2
        title      = "ArgoCD Controller & Server CPU Usage (Prometheus)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 8, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (pod) (rate(container_cpu_usage_seconds_total{namespace=\"argocd\",container!=\"\"}[5m]))"
            legendFormat = "{{pod}}"
          }
        ]
      },
      {
        id         = 3
        title      = "ArgoCD Memory Working Set (Prometheus)"
        type       = "timeseries"
        gridPos    = { h = 7, w = 8, x = 16, y = 0 }
        datasource = { type = "prometheus", uid = "prometheus-eks" }
        targets = [
          {
            expr         = "sum by (pod) (container_memory_working_set_bytes{namespace=\"argocd\",container!=\"\"})"
            legendFormat = "{{pod}}"
          }
        ]
      },
      {
        id         = 4
        title      = "ArgoCD Live Logs (Shipped by Fluentd -> Loki)"
        type       = "logs"
        gridPos    = { h = 10, w = 24, x = 0, y = 7 }
        datasource = { type = "loki", uid = "loki-eks" }
        options = {
          showTime         = true
          showLabels       = true
          wrapLogMessage   = true
          enableLogDetails = true
          sortOrder        = "Descending"
        }
        targets = [
          {
            expr = "{namespace=\"argocd\"}"
          }
        ]
      }
    ]
  })

  dashboard_sonarqube_loki = jsonencode({
    title         = "3. SonarQube, ArgoCD & Apps - Fluentd to Loki Central Logs"
    uid           = "sonarqube-argocd-loki-logs"
    timezone      = "browser"
    schemaVersion = 39
    version       = 1
    refresh       = "15s"
    panels = [
      {
        id         = 1
        title      = "Fluentd -> Loki Log Volume by Namespace (5m)"
        type       = "timeseries"
        gridPos    = { h = 6, w = 24, x = 0, y = 0 }
        datasource = { type = "loki", uid = "loki-eks" }
        targets = [
          {
            expr         = "sum by (namespace) (count_over_time({job=\"fluentd\"}[5m]))"
            legendFormat = "{{namespace}}"
          }
        ]
      },
      {
        id         = 2
        title      = "SonarQube QA & Security Logs (Fluentd -> Loki)"
        type       = "logs"
        gridPos    = { h = 9, w = 12, x = 0, y = 6 }
        datasource = { type = "loki", uid = "loki-eks" }
        options = {
          showTime         = true
          showLabels       = true
          wrapLogMessage   = true
          enableLogDetails = true
          sortOrder        = "Descending"
        }
        targets = [
          {
            expr = "{namespace=\"sonarqube\"}"
          }
        ]
      },
      {
        id         = 3
        title      = "ArgoCD GitOps Logs (Fluentd -> Loki)"
        type       = "logs"
        gridPos    = { h = 9, w = 12, x = 12, y = 6 }
        datasource = { type = "loki", uid = "loki-eks" }
        options = {
          showTime         = true
          showLabels       = true
          wrapLogMessage   = true
          enableLogDetails = true
          sortOrder        = "Descending"
        }
        targets = [
          {
            expr = "{namespace=\"argocd\"}"
          }
        ]
      },
      {
        id         = 4
        title      = "All Platform & App Logs (apps-demo, sonarqube, argocd, backstage)"
        type       = "logs"
        gridPos    = { h = 9, w = 24, x = 0, y = 15 }
        datasource = { type = "loki", uid = "loki-eks" }
        options = {
          showTime         = true
          showLabels       = true
          wrapLogMessage   = true
          enableLogDetails = true
          sortOrder        = "Descending"
        }
        targets = [
          {
            expr = "{namespace=~\"apps-demo|sonarqube|argocd|backstage\"}"
          }
        ]
      }
    ]
  })
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

  values = [
    yamlencode({
      replicas = 0
      service = {
        type = "ClusterIP"
      }
      adminUser     = var.admin_user
      adminPassword = var.admin_password
      persistence = {
        enabled = false
      }
      datasources = {
        "datasources.yaml" = {
          apiVersion = 1
          datasources = [
            {
              name      = "Prometheus"
              uid       = "prometheus-eks"
              type      = "prometheus"
              url       = "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local"
              access    = "proxy"
              isDefault = true
            },
            {
              name      = "Loki"
              uid       = "loki-eks"
              type      = "loki"
              url       = "http://loki.${kubernetes_namespace.grafana.metadata[0].name}.svc.cluster.local:3100"
              access    = "proxy"
              isDefault = false
            }
          ]
        }
      }
      dashboardProviders = {
        "dashboardproviders.yaml" = {
          apiVersion = 1
          providers = [
            {
              name            = "default"
              orgId           = 1
              folder          = "EKS Observability (Prometheus & Loki)"
              type            = "file"
              disableDeletion = false
              editable        = true
              options = {
                path = "/var/lib/grafana/dashboards/default"
              }
            }
          ]
        }
      }
      dashboards = {
        default = {
          "apps-metrics-and-logs" = {
            json = local.dashboard_apps
          }
          "argocd-metrics-and-logs" = {
            json = local.dashboard_argocd
          }
          "sonarqube-and-platform-loki" = {
            json = local.dashboard_sonarqube_loki
          }
        }
      }
    })
  ]
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
      "app.kubernetes.io/name" = "grafana-metrics"
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
