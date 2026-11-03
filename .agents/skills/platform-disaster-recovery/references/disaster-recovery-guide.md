# Guia de Referência: Disaster Recovery e Reconstrução da Plataforma

## 1. Visão Geral da Arquitetura
A plataforma é composta por:
- **Camada de Orquestração:** AWS EKS Cluster (`kube-demo-eks`) com nós gerenciados em subnets privadas e NAT Gateway.
- **Camada de Dados:** AWS RDS PostgreSQL (banco multi-tenant para `backstage_plugin_catalog` e `sonarqube`).
- **Camada de Aplicação:** Backstage Developer Portal (`roadiehq/community-backstage-image`) com proxy nginx e sidecar de sincronização contínua de banco (`backstage-db-sync`).
- **Camada GitOps:** ArgoCD v2.12 gerenciando a sincronização dos repositórios:
  - `cirodasilvaj/backstage-infra`
  - `cirodasilvaj/apps-demo-2026`
  - `cirodasilvaj/bkstg-made-nodejs-demo22`
  - `cirodasilvaj/scaffolder-starter-microservice`
- **Camada de QA & Observabilidade:** SonarQube Community 9.9 LTS, Grafana, Prometheus e Fluentd/Loki.
- **Camada de Identidade:** GitHub App `backstage-devex-cirodasilvaj-2026` (App ID `5586387`) e PAT ativo.

---

## 2. Parâmetros e Segredos Críticos

| Chave | Local Primário | Local Secundário | Finalidade |
| :--- | :--- | :--- | :--- |
| `GH_PAT` | GitHub Secret | K8s Secret `token` | Chamadas autenticadas do Scaffolder para a API do GitHub |
| `GH_APP_ID` | GitHub Secret (`5586387`) | SSM `/backstage/github/app_id` | Identificador do GitHub App |
| `GH_APP_CLIENT_ID` | GitHub Secret (`Iv23liISZZ2QWobzor9w`) | SSM `/backstage/github/client_id` | Client ID público da integração OAuth/App |
| `GH_APP_CLIENT_SECRET` | GitHub Secret | SSM `/backstage/github/client_secret` | Client Secret do GitHub App |
| `GH_APP_PRIVATE_KEY` | GitHub Secret (RSA PEM) | SSM `/backstage/github/private_key` | Chave privada para emissão de JWTs do App |
| `GH_APP_WEBHOOK_SECRET` | GitHub Secret | SSM `/backstage/github/webhook_secret` | Validação de webhooks |

---

## 3. Procedimento de Restauração em 1 Comando

O script principal da skill executa toda a sequência automaticamente:
```bash
bash .agents/skills/platform-disaster-recovery/scripts/full-restore.sh
```

---

## 4. Diagnóstico e Resolução de Problemas

### Problema: EKS describe-cluster retorna Not Found
- **Causa:** O cluster ainda não foi provisionado na nova conta AWS.
- **Solução:** O script executa automaticamente o Terraform em `kube-demo-2026/eks`. Certifique-se de que a conta AWS possui limite disponível de VPCs e Elastic IPs.

### Problema: Backstage em CrashLoopBackOff esperando migrations
- **Causa:** O banco RDS PostgreSQL ainda está iniciando ou a migração Knex ainda não rodou.
- **Solução:** O container `backstage-db-sync` aguarda automaticamente até o Knex criar a tabela `knex_migrations`. Se o banco for novo, o seed dump em `/etc/backstage-db/schema.sql` é injetado automaticamente.
