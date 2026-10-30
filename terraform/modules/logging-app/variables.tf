variable "argocd_namespace" {
  description = "Namespace where ArgoCD runs (the Application CR lives here)"
  type        = string
}

variable "app_namespace" {
  description = "Namespace ArgoCD will create/sync Fluentd into"
  type        = string
}

variable "chart_version" {
  description = "Version of the fluentd Helm chart (fluent/helm-charts)"
  type        = string
}

variable "fluentd_role_arn" {
  description = "IRSA role ARN Fluentd assumes to write to CloudWatch Logs"
  type        = string
}

variable "aws_region" {
  description = "AWS region to write CloudWatch Logs into"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name, used in the CloudWatch log group path"
  type        = string
}
