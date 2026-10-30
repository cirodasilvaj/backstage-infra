variable "namespace" {
  description = "Namespace to install ArgoCD into"
  type        = string
}

variable "chart_version" {
  description = "Version of the argo-cd Helm chart"
  type        = string
}
