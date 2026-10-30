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
