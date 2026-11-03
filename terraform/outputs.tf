output "eks_cluster_name" {
  description = "Target EKS cluster name"
  value       = data.aws_eks_cluster.target.name
}

output "eks_cluster_arn" {
  description = "Target EKS cluster ARN"
  value       = data.aws_eks_cluster.target.arn
}

output "eks_cluster_endpoint" {
  description = "Target EKS cluster API server endpoint"
  value       = data.aws_eks_cluster.target.endpoint
}

output "eks_cluster_ca_data" {
  description = "Base64-encoded CA certificate for the target EKS cluster"
  value       = nonsensitive(data.aws_eks_cluster.target.certificate_authority[0].data)
}

output "eks_kubeconfig_command" {
  description = "Command to configure local kubectl for the EKS cluster"
  value       = "aws eks update-kubeconfig --name ${data.aws_eks_cluster.target.name} --region ${var.aws_region}"
}

output "rds_instance_id" {
  description = "AWS RDS PostgreSQL instance identifier"
  value       = module.rds.db_instance_id
}

output "rds_instance_class" {
  description = "AWS RDS PostgreSQL instance class"
  value       = module.rds.instance_class
}

output "rds_engine_version" {
  description = "AWS RDS PostgreSQL engine version"
  value       = module.rds.engine_version
}

output "rds_endpoint" {
  description = "AWS RDS PostgreSQL connection endpoint (host:port)"
  value       = module.rds.endpoint
}

output "rds_address" {
  description = "AWS RDS PostgreSQL hostname"
  value       = module.rds.address
}

output "rds_port" {
  description = "AWS RDS PostgreSQL port"
  value       = module.rds.port
}

output "rds_db_name" {
  description = "AWS RDS PostgreSQL database name"
  value       = module.rds.db_name
}

output "rds_username" {
  description = "AWS RDS PostgreSQL master username"
  value       = module.rds.username
}

output "argocd_namespace" {
  description = "Namespace where ArgoCD was installed"
  value       = module.argocd.namespace
}

output "argocd_release_name" {
  description = "Helm release name for ArgoCD"
  value       = module.argocd.release_name
}

output "argocd_release_status" {
  description = "Helm release status for ArgoCD"
  value       = module.argocd.release_status
}

output "argocd_chart_version" {
  description = "Installed ArgoCD Helm chart version"
  value       = module.argocd.chart_version
}

output "argocd_service_url" {
  description = "Internal cluster URL for ArgoCD server"
  value       = module.argocd.service_url
}

output "argocd_external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to ArgoCD"
  value       = module.argocd.external_lb_hostname
}

output "argocd_external_url" {
  description = "Public HTTP URL (port 80) to access the ArgoCD Web UI in a browser"
  value       = module.argocd.external_url
}

output "argocd_external_url_8080" {
  description = "Public HTTP URL (port 8080) to access the ArgoCD Web UI in a browser"
  value       = module.argocd.external_url_8080
}


output "argocd_get_admin_password_command" {
  description = "Run this after apply to retrieve the ArgoCD initial admin password"
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "argocd_port_forward_command" {
  description = "Run this to reach the ArgoCD UI at https://localhost:8080"
  value       = "kubectl -n ${var.argocd_namespace} port-forward svc/argocd-server 8080:443"
}

output "backstage_application_name" {
  description = "ArgoCD Application name for Backstage"
  value       = module.backstage_app.application_name
}

output "backstage_namespace" {
  description = "Namespace where Backstage is deployed by ArgoCD"
  value       = module.backstage_app.app_namespace
}

output "backstage_repo_url" {
  description = "Git repository URL watched by ArgoCD for Backstage manifests"
  value       = module.backstage_app.repo_url
}

output "backstage_repo_path" {
  description = "Repository path watched by ArgoCD for Backstage manifests"
  value       = module.backstage_app.repo_path
}

output "backstage_service_url" {
  description = "Internal cluster URL for Backstage"
  value       = module.backstage_app.service_url
}

output "backstage_external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to Backstage"
  value       = module.backstage_app.external_lb_hostname
}

output "backstage_external_url" {
  description = "External HTTP URL (port 80) for the Backstage UI"
  value       = module.backstage_app.external_url
}

output "backstage_external_url_7007" {
  description = "External HTTP URL (port 7007) for the Backstage UI"
  value       = module.backstage_app.external_url_7007
}

output "backstage_basic_auth_user" {
  description = "Basic authentication username for the Backstage web UI"
  value       = module.backstage_app.basic_auth_user
}

output "backstage_basic_auth_password" {
  description = "Basic authentication password for the Backstage web UI"
  value       = module.backstage_app.basic_auth_password
  sensitive   = true
}

output "backstage_db_dump_download_url" {
  description = "Direct URL to download the live AWS RDS PostgreSQL dump (.sql)"
  value       = module.backstage_app.db_dump_download_url
}

output "backstage_db_schema_download_url" {
  description = "Direct URL to download the base PostgreSQL schema (.sql)"
  value       = module.backstage_app.db_schema_download_url
}

output "backstage_db_dump_curl_command" {
  description = "Run this command locally to download the live RDS PostgreSQL dump (.sql)"
  value       = "curl -u ${module.backstage_app.basic_auth_user}:${module.backstage_app.basic_auth_password} -o backstage-rds-dump.sql ${module.backstage_app.db_dump_download_url}"
  sensitive   = true
}

output "backstage_db_restore_command" {
  description = "Command to restore the downloaded SQL dump into RDS on a new installation"
  value       = "PGPASSWORD='${var.rds_db_password}' psql -h ${module.rds.address} -p ${module.rds.port} -U ${module.rds.username} -d ${module.rds.db_name} -f backstage-rds-dump.sql"
  sensitive   = true
}

output "backstage_k8s_cluster_status_url" {
  description = "Direct URL to inspect Backstage's live Kubernetes cluster connection status JSON"
  value       = module.backstage_app.k8s_cluster_status_url
}

output "backstage_k8s_service_account" {
  description = "Kubernetes ServiceAccount used by Backstage to connect to the EKS cluster"
  value       = module.backstage_app.k8s_service_account
}

output "backstage_k8s_cluster_role" {
  description = "Kubernetes ClusterRole granting Backstage read access to EKS cluster workloads"
  value       = module.backstage_app.k8s_cluster_role
}


output "backstage_port_forward_command" {
  description = "Run this to reach the Backstage UI at http://localhost:7007 once ArgoCD has synced it"
  value       = "kubectl -n ${var.backstage_namespace} port-forward svc/backstage 7007:7007"
}

output "grafana_namespace" {
  description = "Namespace where Grafana was installed"
  value       = module.grafana.namespace
}

output "grafana_release_name" {
  description = "Helm release name for Grafana"
  value       = module.grafana.release_name
}

output "grafana_release_status" {
  description = "Helm release status for Grafana"
  value       = module.grafana.release_status
}

output "grafana_chart_version" {
  description = "Installed Grafana Helm chart version"
  value       = module.grafana.chart_version
}

output "grafana_service_url" {
  description = "Internal cluster URL for Grafana"
  value       = module.grafana.service_url
}

output "grafana_prometheus_datasource_url" {
  description = "Prometheus datasource URL configured in Grafana"
  value       = module.grafana.prometheus_datasource_url
}

output "grafana_external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to Grafana"
  value       = module.grafana.external_lb_hostname
}

output "grafana_external_url" {
  description = "Public HTTP URL (port 80) to access the Grafana UI"
  value       = module.grafana.external_url
}

output "grafana_external_url_3000" {
  description = "Public HTTP URL (port 3000) to access the Grafana UI"
  value       = module.grafana.external_url_3000
}

output "grafana_admin_user" {
  description = "Admin username for the Grafana Web UI"
  value       = module.grafana.admin_user
}

output "grafana_admin_password" {
  description = "Admin password for the Grafana Web UI"
  value       = module.grafana.admin_password
  sensitive   = true
}

output "grafana_admin_password_command" {
  description = "Run this after apply to retrieve the Grafana admin password"
  value       = "kubectl -n ${module.grafana.namespace} get secret grafana -o jsonpath='{.data.admin-password}' | base64 -d"
}

output "grafana_port_forward_command" {
  description = "Run this to reach the Grafana UI at http://localhost:3000"
  value       = "kubectl -n ${module.grafana.namespace} get secret grafana >/dev/null && kubectl -n ${module.grafana.namespace} port-forward svc/grafana 3000:80"
}

output "fluentd_namespace" {
  description = "Namespace where Fluentd was installed"
  value       = module.fluentd.namespace
}

output "fluentd_release_name" {
  description = "Helm release name for Fluentd"
  value       = module.fluentd.release_name
}

output "fluentd_release_status" {
  description = "Helm release status for Fluentd"
  value       = module.fluentd.release_status
}

output "fluentd_chart_version" {
  description = "Installed Fluentd Helm chart version"
  value       = module.fluentd.chart_version
}

output "sonarqube_namespace" {
  description = "Namespace where SonarQube is deployed"
  value       = module.sonarqube.namespace
}

output "sonarqube_service_url" {
  description = "Internal cluster URL for SonarQube"
  value       = module.sonarqube.service_url
}

output "sonarqube_external_lb_hostname" {
  description = "AWS LoadBalancer DNS hostname for external access to SonarQube"
  value       = module.sonarqube.external_lb_hostname
}

output "sonarqube_external_url" {
  description = "Public HTTP URL (port 80) to access the SonarQube QA & Security UI"
  value       = module.sonarqube.external_url
}

output "sonarqube_external_url_9000" {
  description = "Public HTTP URL (port 9000) to access the SonarQube QA & Security UI"
  value       = module.sonarqube.external_url_9000
}

output "sonarqube_admin_user" {
  description = "Admin username for the SonarQube Web UI"
  value       = module.sonarqube.admin_user
}

output "sonarqube_admin_password" {
  description = "Admin password configured for the SonarQube Web UI (initial default before UP is 'admin')"
  value       = module.sonarqube.admin_password
  sensitive   = true
}

output "sonarqube_security_plugins_installed" {
  description = "QA & Security plugins automatically installed in SonarQube"
  value       = module.sonarqube.security_plugins_installed
}

# ==============================================================================
# Route 53 Dynamic DNS Endpoints
# ==============================================================================

output "route53_discovered_zone_id" {
  description = "Discovered Route 53 public hosted zone ID for the lab account"
  value       = local.lab_zone_id
}

output "route53_discovered_domain" {
  description = "Discovered Route 53 base domain for the lab account"
  value       = local.lab_domain
}

output "route53_friendly_urls" {
  description = "Clean, friendly HTTP URLs mapped to Route 53 for all services"
  value = {
    for k, r in aws_route53_record.services :
    k => "http://${r.fqdn}"
  }
}

output "route53_backstage_url" {
  description = "Friendly Route 53 URL for Backstage UI"
  value       = local.has_lab_zone ? "http://backstage.${local.lab_domain}" : module.backstage_app.external_url
}

output "route53_grafana_url" {
  description = "Friendly Route 53 URL for Grafana UI"
  value       = local.has_lab_zone ? "http://grafana.${local.lab_domain}" : module.grafana.external_url
}

output "route53_argocd_url" {
  description = "Friendly Route 53 URL for ArgoCD Web UI"
  value       = local.has_lab_zone ? "http://argocd.${local.lab_domain}" : module.argocd.external_url
}

output "route53_sonarqube_url" {
  description = "Friendly Route 53 URL for SonarQube QA & Security UI"
  value       = local.has_lab_zone ? "http://sonarqube.${local.lab_domain}" : module.sonarqube.external_url
}

output "aws_account_id" {
  description = "Auto-discovered AWS Account ID"
  value       = local.aws_account_id
}

output "acm_certificate_arn" {
  description = "Validated ACM Wildcard SSL/TLS Certificate ARN for HTTPS"
  value       = local.has_lab_zone ? aws_acm_certificate.lab_cert[0].arn : ""
}

output "route53_friendly_https_urls" {
  description = "Clean, friendly HTTPS URLs mapped to Route 53 with ACM SSL/TLS"
  value = {
    for k, r in aws_route53_record.services :
    k => "https://${r.fqdn}"
  }
}

# ==============================================================================
# AWS Parameter Store Output (Single Source of Truth)
# ==============================================================================

output "ssm_credentials_parameter_name" {
  description = "Single unified AWS SSM Parameter Store resource containing ALL endpoints and credentials"
  value       = aws_ssm_parameter.platform_credentials.name
}

output "ssm_credentials_parameter_arn" {
  description = "ARN of the unified AWS SSM Parameter Store resource"
  value       = aws_ssm_parameter.platform_credentials.arn
}

output "how_to_retrieve_credentials_command" {
  description = "AWS CLI command to retrieve all endpoints and credentials securely"
  value       = "aws ssm get-parameter --name '${aws_ssm_parameter.platform_credentials.name}' --with-decryption --query 'Parameter.Value' --output text | jq ."
}




