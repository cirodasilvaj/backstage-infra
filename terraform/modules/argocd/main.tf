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
