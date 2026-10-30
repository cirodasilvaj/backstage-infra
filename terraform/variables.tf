variable "aws_region" {
  description = "AWS region of the target EKS cluster"
  type        = string
  default     = "us-east-1"
}

variable "eks_cluster_name" {
  description = "Name of the existing EKS cluster (provisioned in kube-demo-2026/eks)"
  type        = string
  default     = "kube-demo-eks"
}

variable "argocd_namespace" {
  description = "Namespace where ArgoCD itself is installed"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "Version of the argo-cd Helm chart (argoproj/argo-helm)"
  type        = string
  default     = "7.7.3"
}

variable "backstage_namespace" {
  description = "Namespace ArgoCD will deploy Backstage into"
  type        = string
  default     = "backstage"
}

variable "backstage_repo_url" {
  description = "Git repo ArgoCD watches for the Backstage manifests"
  type        = string
  default     = "https://github.com/cirodasilvaj/backstate-infra.git"
}

variable "backstage_repo_path" {
  description = "Path inside backstage_repo_url with the Backstage manifests"
  type        = string
  default     = "k8s-manifests/backstage"
}

variable "backstage_target_revision" {
  description = "Git branch/tag ArgoCD tracks for the Backstage manifests"
  type        = string
  default     = "main"
}

variable "monitoring_namespace" {
  description = "Namespace ArgoCD will deploy kube-prometheus-stack into"
  type        = string
  default     = "monitoring"
}

variable "monitoring_chart_version" {
  description = "Version of the kube-prometheus-stack Helm chart (prometheus-community/helm-charts)"
  type        = string
  default     = "65.5.1"
}
