# Register SonarQube as an ArgoCD Application managing k8s-manifests/sonarqube
resource "kubernetes_manifest" "sonarqube_application" {
  manifest = yamldecode(templatefile("${path.module}/../../../k8s-manifests/argo/application-sonarqube.yaml", {
    argocd_namespace = var.argocd_namespace
    app_namespace    = var.app_namespace
    repo_url         = var.repo_url
    repo_path        = var.repo_path
    target_revision  = var.target_revision
  }))
}

# RDS PostgreSQL connection secret for SonarQube
resource "kubernetes_secret_v1" "sonarqube_db_credentials" {
  metadata {
    name      = "sonarqube-db-credentials"
    namespace = var.app_namespace
    labels = {
      app = "sonarqube"
    }
  }

  data = {
    POSTGRES_HOST     = var.db_host
    POSTGRES_PORT     = var.db_port
    POSTGRES_USER     = var.db_username
    POSTGRES_PASSWORD = var.db_password
    SONAR_JDBC_URL    = "jdbc:postgresql://${var.db_host}:${var.db_port}/sonarqube"
  }

  type = "Opaque"
}

# Admin credentials secret for SonarQube postStart password configuration
resource "kubernetes_secret_v1" "sonarqube_admin_credentials" {
  metadata {
    name      = "sonarqube-admin-credentials"
    namespace = var.app_namespace
    labels = {
      app = "sonarqube"
    }
  }

  data = {
    SONAR_ADMIN_USER     = var.admin_user
    SONAR_ADMIN_PASSWORD = var.admin_password
  }

  type = "Opaque"
}

# External AWS LoadBalancer service for browser access to the SonarQube Web UI
resource "kubernetes_service_v1" "sonarqube_external" {
  metadata {
    name      = "sonarqube-external"
    namespace = var.app_namespace
    labels = {
      app = "sonarqube"
    }
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-scheme" = "internet-facing"
    }
  }

  spec {
    type = "LoadBalancer"

    selector = {
      app = "sonarqube"
    }

    port {
      name        = "http"
      port        = 80
      target_port = 9000
      protocol    = "TCP"
    }

    port {
      name        = "sonarqube-9000"
      port        = 9000
      target_port = 9000
      protocol    = "TCP"
    }
  }

  wait_for_load_balancer = true

  depends_on = [
    kubernetes_manifest.sonarqube_application,
    kubernetes_secret_v1.sonarqube_db_credentials,
    kubernetes_secret_v1.sonarqube_admin_credentials,
  ]
}
