# The Application manifest lives in k8s-manifests/argo so it stays reviewable
# as plain YAML; Terraform just applies it and fills in the per-environment
# values (namespace, repo, path, branch).
resource "kubernetes_manifest" "backstage_application" {
  manifest = yamldecode(templatefile("${path.module}/../../../k8s-manifests/argo/application-backstage.yaml", {
    argocd_namespace = var.argocd_namespace
    app_namespace    = var.app_namespace
    repo_url         = var.repo_url
    repo_path        = var.repo_path
    target_revision  = var.target_revision
  }))
}

# Basic authentication credentials secret for the Backstage web UI proxy.
resource "kubernetes_secret_v1" "backstage_basic_auth" {
  metadata {
    name      = "backstage-basic-auth"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
  }

  data = {
    username = var.auth_user
    password = var.auth_password
  }

  type = "Opaque"
}

# RDS PostgreSQL connection credentials secret for Backstage and DB dump sidecar.
resource "kubernetes_secret_v1" "backstage_db_credentials" {
  metadata {
    name      = "backstage-db-credentials"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
  }

  data = {
    POSTGRES_HOST     = var.db_host
    POSTGRES_PORT     = var.db_port
    POSTGRES_DB       = var.db_name
    POSTGRES_USER     = var.db_username
    POSTGRES_PASSWORD = var.db_password
  }

  type = "Opaque"
}

# Kubernetes cluster integration configuration secret for Backstage (@backstage/plugin-kubernetes-backend).
resource "kubernetes_secret_v1" "backstage_k8s_config" {
  metadata {
    name      = "backstage-k8s-config"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
  }

  data = {
    K8S_CLUSTER_NAME = var.cluster_name
    K8S_CLUSTER_URL  = "https://kubernetes.default.svc"
    APP_CONFIG_kubernetes = jsonencode({
      serviceLocatorMethod = {
        type = "multiTenant"
      }
      clusterLocatorMethods = [
        {
          type = "config"
          clusters = [
            {
              name              = var.cluster_name
              url               = "https://kubernetes.default.svc"
              authProvider      = "serviceAccount"
              skipTLSVerify     = true
              skipMetricsLookup = false
            }
          ]
        }
      ]
    })
  }

  type = "Opaque"
}

# GitHub Token Secret for Backstage Scaffolder repository creation and catalog integrations
resource "kubernetes_secret_v1" "backstage_github_credentials" {
  metadata {
    name      = "backstage-github-credentials"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
  }

  data = {
    token = var.github_token
  }

  type = "Opaque"
}

# External LoadBalancer service for demo access to the Backstage UI.
resource "kubernetes_service_v1" "backstage_external" {
  metadata {
    name      = "backstage-external"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
    annotations = merge(
      {
        "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
      },
      var.acm_certificate_arn != "" ? {
        "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"        = var.acm_certificate_arn
        "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"       = "https"
        "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "http"
      } : {}
    )
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "backstage"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 7007
      protocol    = "TCP"
    }

    dynamic "port" {
      for_each = var.acm_certificate_arn != "" ? [1] : []
      content {
        name        = "https"
        port        = 443
        target_port = 7007
        protocol    = "TCP"
      }
    }

    port {
      name        = "backstage"
      port        = 7007
      target_port = 7007
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = true

  depends_on = [
    kubernetes_manifest.backstage_application,
    kubernetes_secret_v1.backstage_basic_auth,
    kubernetes_secret_v1.backstage_db_credentials,
    kubernetes_secret_v1.backstage_k8s_config,
    kubernetes_secret_v1.backstage_github_credentials,
  ]
}
