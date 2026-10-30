variable "argocd_namespace" {
  description = "Namespace where ArgoCD runs (the Application CR lives here)"
  type        = string
}

variable "app_namespace" {
  description = "Namespace ArgoCD will create/sync the monitoring stack into"
  type        = string
}

variable "chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart"
  type        = string
}
