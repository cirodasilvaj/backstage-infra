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

variable "github_token" {
  description = "GitHub Personal Access Token for Backstage Scaffolder repository creation and catalog integrations"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_app_id" {
  description = "GitHub App ID for administrative access to GitHub"
  type        = string
  default     = ""
}

variable "github_app_client_id" {
  description = "GitHub App Client ID"
  type        = string
  default     = ""
}

variable "github_app_client_secret" {
  description = "GitHub App Client Secret"
  type        = string
  default     = ""
  sensitive   = true
}

variable "github_app_webhook_secret" {
  description = "GitHub App Webhook Secret"
  type        = string
  default     = "development-webhook-secret"
  sensitive   = true
}

variable "github_app_private_key" {
  description = "GitHub App RSA Private Key PEM"
  type        = string
  default     = ""
  sensitive   = true
}

variable "acm_certificate_arn" {
  description = "AWS ACM SSL/TLS certificate ARN for HTTPS termination on the external LoadBalancer"
  type        = string
  default     = ""
}

