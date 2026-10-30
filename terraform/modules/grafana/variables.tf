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
