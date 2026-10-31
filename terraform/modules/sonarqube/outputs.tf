output "namespace" {
  description = "Namespace where SonarQube is deployed"
  value       = var.app_namespace
}

output "service_url" {
  description = "Internal cluster URL for SonarQube"
  value       = "http://sonarqube.${var.app_namespace}.svc.cluster.local:9000"
}

output "external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to SonarQube"
  value       = try(kubernetes_service_v1.sonarqube_external.status[0].load_balancer[0].ingress[0].hostname, "")
}

output "external_url" {
  description = "External HTTP URL (port 80) for the SonarQube Web UI"
  value       = try("http://${kubernetes_service_v1.sonarqube_external.status[0].load_balancer[0].ingress[0].hostname}", "")
}

output "external_url_9000" {
  description = "External HTTP URL (port 9000) for the SonarQube Web UI"
  value       = try("http://${kubernetes_service_v1.sonarqube_external.status[0].load_balancer[0].ingress[0].hostname}:9000", "")
}

output "admin_user" {
  description = "Admin username for SonarQube Web UI"
  value       = var.admin_user
}

output "admin_password" {
  description = "Admin password configured for SonarQube Web UI (initial default before UP is 'admin')"
  value       = var.admin_password
}

output "security_plugins_installed" {
  description = "QA and Security plugins installed in SonarQube (/opt/sonarqube/extensions/plugins)"
  value = [
    "sonar-dependency-check-plugin-4.0.1.jar (OWASP Dependency-Check Vulnerability Scanner)",
    "sonar-findbugs-plugin-4.2.10.jar (SpotBugs + FindSecBugs Security Audit)",
    "sonar-yaml-plugin-1.9.1.jar (YAML / Kubernetes Security & Lint)",
  ]
}
