variable "argocd_namespace" {
  description = "Namespace where ArgoCD runs"
  type        = string
  default     = "argocd"
}

variable "app_namespace" {
  description = "Namespace where SonarQube is deployed"
  type        = string
  default     = "sonarqube"
}

variable "repo_url" {
  description = "Git repository URL watched by ArgoCD"
  type        = string
}

variable "repo_path" {
  description = "Path inside repo_url containing the SonarQube Kubernetes manifests"
  type        = string
  default     = "k8s-manifests/sonarqube"
}

variable "target_revision" {
  description = "Git branch/revision tracked by ArgoCD"
  type        = string
  default     = "main"
}

variable "admin_user" {
  description = "Admin username for SonarQube Web UI"
  type        = string
  default     = "admin"
}

variable "admin_password" {
  description = "Admin password configured for SonarQube Web UI"
  type        = string
  default     = "Sonar@2026"
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

variable "db_username" {
  description = "RDS PostgreSQL master username"
  type        = string
}

variable "db_password" {
  description = "RDS PostgreSQL master password"
  type        = string
}
