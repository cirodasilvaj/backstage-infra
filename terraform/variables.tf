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
  default     = "https://github.com/cirodasilvaj/backstage-infra.git"
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

variable "backstage_auth_user" {
  description = "Basic authentication username for the Backstage web UI"
  type        = string
  default     = "admin"
}

variable "backstage_auth_password" {
  description = "Basic authentication password for the Backstage web UI"
  type        = string
  default     = "Backstage@2026"
}

variable "rds_db_identifier" {
  description = "Identifier for the Backstage AWS RDS PostgreSQL instance"
  type        = string
  default     = "backstage-postgres"
}

variable "rds_instance_class" {
  description = "Cheapest AWS RDS PostgreSQL instance class"
  type        = string
  default     = "db.t4g.micro"
}

variable "rds_db_name" {
  description = "Initial PostgreSQL database name for Backstage"
  type        = string
  default     = "backstage_plugin_catalog"
}

variable "rds_db_username" {
  description = "Master username for Backstage RDS PostgreSQL"
  type        = string
  default     = "backstage"
}

variable "rds_db_password" {
  description = "Master password for Backstage RDS PostgreSQL"
  type        = string
  default     = "BackstageRds2026!"
}

variable "grafana_namespace" {
  description = "Namespace where Grafana is installed"
  type        = string
  default     = "grafana"
}

variable "grafana_chart_version" {
  description = "Version of the grafana/grafana Helm chart"
  type        = string
  default     = "8.6.4"
}

variable "prometheus_namespace" {
  description = "Namespace where the Prometheus server (installed by kube-demo-2026/eks) lives"
  type        = string
  default     = "monitoring"
}

variable "fluentd_namespace" {
  description = "Namespace where Fluentd is installed"
  type        = string
  default     = "logging"
}

variable "fluentd_chart_version" {
  description = "Version of the fluent/fluentd Helm chart"
  type        = string
  default     = "0.5.3"
}
