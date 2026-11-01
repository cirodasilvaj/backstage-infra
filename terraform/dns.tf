# ==============================================================================
# Auto-Descoberta da Hosted Zone Route 53 e Delegação de Nomes dos Serviços
# ==============================================================================

# 1. Lista todos os IDs de Hosted Zones da conta atual da AWS
data "aws_route53_zones" "all" {}

# 2. Obtém os detalhes completos de cada zona para inspecionar nome e se é pública
data "aws_route53_zone" "all" {
  for_each = toset(data.aws_route53_zones.all.ids)
  zone_id  = each.value
}

locals {
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
# 3. Registros CNAME dinâmicos no Route 53
# ==============================================================================
resource "aws_route53_record" "services" {
  for_each = local.has_lab_zone ? local.service_endpoints : {}

  zone_id = local.lab_zone_id
  name    = "${each.key}.${local.lab_domain}"
  type    = "CNAME"
  ttl     = 60
  records = [each.value]
}
