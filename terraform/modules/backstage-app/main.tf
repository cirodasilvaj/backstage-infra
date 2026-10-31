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

# External LoadBalancer service for demo access to the Backstage UI.
resource "kubernetes_service_v1" "backstage_external" {
  metadata {
    name      = "backstage-external"
    namespace = var.app_namespace
    labels = {
      app = "backstage"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
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
  ]
}
