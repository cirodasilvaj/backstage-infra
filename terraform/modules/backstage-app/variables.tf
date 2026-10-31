variable "argocd_namespace" {
  description = "Namespace where ArgoCD runs (the Application CR lives here)"
  type        = string
}

variable "app_namespace" {
  description = "Namespace ArgoCD will create/sync Backstage into"
  type        = string
}

variable "repo_url" {
  description = "Git repo ArgoCD watches"
  type        = string
}

variable "repo_path" {
  description = "Path inside repo_url with the Backstage manifests"
  type        = string
}

variable "target_revision" {
  description = "Git branch/tag ArgoCD tracks"
  type        = string
}

variable "auth_user" {
  description = "Basic authentication username for the Backstage UI"
  type        = string
  default     = "admin"
}

variable "auth_password" {
  description = "Basic authentication password for the Backstage UI"
  type        = string
  default     = "Backstage@2026"
}

variable "db_host" {
  description = "RDS PostgreSQL hostname"
  type        = string
}

variable "db_port" {
  description = "RDS PostgreSQL port"
  type        = string
  default     = "5432"
}

variable "db_name" {
  description = "RDS PostgreSQL database name"
  type        = string
}

variable "db_username" {
  description = "RDS PostgreSQL username"
  type        = string
}

variable "db_password" {
  description = "RDS PostgreSQL password"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS Kubernetes cluster connected to Backstage"
  type        = string
  default     = "kube-demo-eks"
}

