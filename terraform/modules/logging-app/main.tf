# Registers Fluentd (shipping container logs to CloudWatch Logs) as an
# ArgoCD Application, the same GitOps pattern used for Backstage/monitoring.
resource "kubernetes_manifest" "logging_application" {
  manifest = yamldecode(templatefile("${path.module}/../../../k8s-manifests/argo/application-logging.yaml", {
    argocd_namespace = var.argocd_namespace
    app_namespace    = var.app_namespace
    chart_version    = var.chart_version
    fluentd_role_arn = var.fluentd_role_arn
    aws_region       = var.aws_region
    cluster_name     = var.cluster_name
  }))
}
