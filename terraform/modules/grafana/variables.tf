variable "namespace" {
  description = "Namespace to install Grafana into"
  type        = string
  default     = "grafana"
}

variable "chart_version" {
  description = "Version of the grafana/grafana Helm chart"
  type        = string
  default     = "8.6.4"
}

variable "prometheus_namespace" {
  description = "Namespace where the Prometheus server (installed by kube-demo-2026/eks) lives"
  type        = string
  default     = "monitoring"
}

variable "admin_user" {
  description = "Admin username for Grafana Web UI"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Admin password for Grafana Web UI"
  type        = string
  default     = "Grafana@2026"
}

variable "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  type        = string
  default     = "argocd"
}

variable "repo_url" {
  description = "Git repository URL containing k8s-manifests/grafana"
  type        = string
  default     = "https://github.com/cirodasilvaj/backstage-infra.git"
}

variable "repo_path" {
  description = "Path inside repo_url for Grafana manifests"
  type        = string
  default     = "k8s-manifests/grafana"
}

variable "target_revision" {
  description = "Git branch/revision tracked by ArgoCD"
  type        = string
  default     = "main"
}
