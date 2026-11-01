# ==============================================================================
# AWS Systems Manager (SSM) Parameter Store: Single Source of Truth
# Todos os Endpoints, URLs, Certificados e Credenciais em um Único Recurso Seguro
# ==============================================================================

resource "aws_ssm_parameter" "platform_credentials" {
  name        = "/kube-demo-2026/platform/credentials"
  description = "Single unified directory of all service URLs, endpoints, and credentials for the platform"
  type        = "SecureString"
  tier        = "Standard"

  value = jsonencode({
    metadata = {
      project          = "kube-demo-2026"
      environment      = "sandbox"
      aws_account_id   = local.aws_account_id
      route53_domain   = local.lab_domain
      route53_zone_id  = local.lab_zone_id
      acm_cert_arn     = local.has_lab_zone ? aws_acm_certificate.lab_cert[0].arn : ""
      single_store_ref = "/kube-demo-2026/platform/credentials"
    }
    endpoints_https = {
      backstage  = local.has_lab_zone ? "https://backstage.${local.lab_domain}" : module.backstage_app.external_url
      argocd     = local.has_lab_zone ? "https://argocd.${local.lab_domain}" : module.argocd.external_url
      sonarqube  = local.has_lab_zone ? "https://sonarqube.${local.lab_domain}" : module.sonarqube.external_url
      grafana    = local.has_lab_zone ? "https://grafana.${local.lab_domain}" : module.grafana.external_url
      keycloak   = local.has_lab_zone ? "https://sso.${local.lab_domain}" : ""
      python_app = local.has_lab_zone ? "https://python.${local.lab_domain}" : ""
      dotnet_app = local.has_lab_zone ? "https://dotnet.${local.lab_domain}" : ""
    }
    endpoints_internal = {
      samba_ad_ldap  = local.has_lab_zone ? "ldap://ad.${local.lab_domain}:389" : "ldap://10.0.11.246:389"
      freeradius_mfa = local.has_lab_zone ? "radius.${local.lab_domain}:1812" : "10.0.11.246:1812"
      prometheus_k8s = "http://prometheus-server.monitoring.svc.cluster.local:80"
      loki_logs      = "http://loki.monitoring.svc.cluster.local:3100"
      rds_postgresql = "${module.rds.address}:${module.rds.port}"
    }
    credentials = {
      backstage = {
        username    = "admin"
        password    = var.backstage_auth_password
        db_dump_url = local.has_lab_zone ? "https://backstage.${local.lab_domain}/backstage-rds-dump.sql" : module.backstage_app.db_dump_download_url
      }
      argocd = {
        username             = "admin"
        get_password_command = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
      }
      sonarqube = {
        username = "admin"
        password = var.sonarqube_admin_password
      }
      grafana = {
        username = "admin"
        password = module.grafana.admin_password
      }
      rds_postgresql = {
        host     = module.rds.address
        port     = module.rds.port
        database = module.rds.db_name
        username = module.rds.username
        password = var.rds_db_password
      }
      samba_active_directory = {
        realm    = "lab.internal"
        username = "Administrator"
        password = "SuaSenhaForte123!"
      }
      keycloak_sso = {
        username = "admin"
        password = "KeycloakAdmin2026!"
      }
      freeradius_mfa = {
        shared_secret = "RadiusSecret2026!"
      }
    }
  })

  tags = {
    Name        = "kube-demo-2026-platform-credentials"
    CostCenter  = "devops-platform-cloud"
    Environment = "sandbox"
    ManagedBy   = "terraform"
    Project     = "backstage-infra"
    Security    = "confidential"
  }
}
