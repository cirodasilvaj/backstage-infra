variable "namespace" {
  description = "Namespace to install Fluentd into"
  type        = string
  default     = "logging"
}

variable "chart_version" {
  description = "Version of the fluent/fluentd Helm chart"
  type        = string
  default     = "0.5.3"
}
