# Registers kube-prometheus-stack (Prometheus + Alertmanager + Grafana) as
# an ArgoCD Application, the same GitOps pattern used for Backstage: ArgoCD
# owns the install/upgrade/drift-correction going forward.
resource "kubernetes_manifest" "monitoring_application" {
  manifest = yamldecode(templatefile("${path.module}/../../../k8s-manifests/argo/application-monitoring.yaml", {
    argocd_namespace = var.argocd_namespace
    app_namespace    = var.app_namespace
    chart_version    = var.chart_version
  }))
}
