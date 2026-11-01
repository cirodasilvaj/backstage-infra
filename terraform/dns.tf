# ==============================================================================
# Auto-Descoberta da Conta AWS, Hosted Zone Route 53 e Certificado SSL/TLS ACM
# ==============================================================================

# 1. Identidade da Conta AWS
data "aws_caller_identity" "current" {}

# 2. Lista todos os IDs de Hosted Zones da conta atual da AWS
data "aws_route53_zones" "all" {}

# 3. Obtém os detalhes completos de cada zona para inspecionar nome e se é pública
data "aws_route53_zone" "all" {
  for_each = toset(data.aws_route53_zones.all.ids)
  zone_id  = each.value
}

locals {
  aws_account_id = data.aws_caller_identity.current.account_id

  # Filtra a zona pública fornecida pela conta temporária do laboratório (*realhandsonlabs.net)
  lab_zones = [
    for z in data.aws_route53_zone.all : z
    if can(regex("realhandsonlabs\\.net", z.name)) && !z.private_zone
  ]

  has_lab_zone = length(local.lab_zones) > 0
  lab_zone_id  = local.has_lab_zone ? local.lab_zones[0].zone_id : ""
  # Remove o ponto final do FQDN (ex: "123456.realhandsonlabs.net." -> "123456.realhandsonlabs.net")
  lab_domain = local.has_lab_zone ? trimsuffix(local.lab_zones[0].name, ".") : ""

  # Mapeia os prefixos dos serviços para os hostnames dos LoadBalancers provisionados no EKS
  service_endpoints = {
    backstage = module.backstage_app.external_lb_hostname
    grafana   = module.grafana.external_lb_hostname
    argocd    = module.argocd.external_lb_hostname
    sonarqube = module.sonarqube.external_lb_hostname
  }
}

# ==============================================================================
# 4. Registros CNAME dinâmicos no Route 53
# ==============================================================================
resource "aws_route53_record" "services" {
  for_each = local.has_lab_zone ? local.service_endpoints : {}

  zone_id = local.lab_zone_id
  name    = "${each.key}.${local.lab_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [each.value]
}

# ==============================================================================
# 5. Solicitação do Certificado SSL/TLS Wildcard no AWS Certificate Manager (ACM)
# ==============================================================================
resource "aws_acm_certificate" "lab_cert" {
  count = local.has_lab_zone ? 1 : 0

  domain_name               = "*.${local.lab_domain}"
  subject_alternative_names = [local.lab_domain]
  validation_method         = "DNS"

  tags = {
    Name = "${local.lab_domain}-acm-wildcard"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ==============================================================================
# 6. Registros CNAME de Validação DNS no Route 53
# ==============================================================================
resource "aws_route53_record" "cert_validation" {
  for_each = local.has_lab_zone ? {
    for dvo in aws_acm_certificate.lab_cert[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = local.lab_zone_id
}

# ==============================================================================
# 7. Validação e Conclusão do Certificado ACM
# ==============================================================================
resource "aws_acm_certificate_validation" "lab_cert" {
  count = local.has_lab_zone ? 1 : 0

  certificate_arn         = aws_acm_certificate.lab_cert[0].arn
  validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
}
