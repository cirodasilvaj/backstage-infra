# Backstage Configuration & State Backup

Este diretório contém o backup completo das configurações ativas, banco de dados e manifestos Kubernetes do **Backstage Developer Portal**.

---

## Conteúdo do Diretório

| Arquivo | Descrição |
| :--- | :--- |
| `backstage-rds-dump.sql` | Dump SQL completo do AWS RDS PostgreSQL 16 (tabelas `knex_migrations`, `final_entities`, `refresh_state`, etc.). |
| `app-config.production.yaml` | Arquivo `app-config.yaml` ativo com integrações GitHub, regras de catálogo e configurações de banco de dados. |
| `catalog-entities.yaml` | Entidades estáticas base (usuário `guest` e grupo `platform-team`). |
| `configmap-backstage-app-config.yaml` | Manifest do ConfigMap Kubernetes contendo os arquivos de configuração do Backstage. |
| `deployment-backstage.yaml` | Manifest do Deployment Kubernetes com os 3 containers (`backstage-auth-proxy`, `backstage-db-sync`, `backstage`). |
| `service-backstage.yaml` | Manifest do Service ClusterIP interno (porta 7007). |
| `service-backstage-external.yaml` | Manifest do Service LoadBalancer externo (portas 80, 443 com certificado ACM e 7007). |
| `serviceaccount-backstage.yaml` | ServiceAccount do Backstage para autenticação no Kubernetes API server. |
| `clusterroles.yaml` | ClusterRoles com permissões de deployer e reader no cluster. |
| `clusterrolebindings.yaml` | Bindings associando a ServiceAccount `backstage` às ClusterRoles. |
| `secrets-template.yaml` | Template declarativo dos Secrets necessários (`backstage-db-credentials`, `backstage-github-credentials`, etc.). |
| `k8s-cluster-status.json` | Snapshot do status de conectividade e contagem de recursos do cluster EKS. |

---

## Como Restaurar a partir deste Diretório

### 1. Restaurar o Banco de Dados no RDS
```bash
kubectl exec -i -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
  'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
  < backup/backstage-rds-dump.sql
```

### 2. Aplicar os Manifestos de Configuração
```bash
kubectl apply -f backup/serviceaccount-backstage.yaml
kubectl apply -f backup/clusterroles.yaml
kubectl apply -f backup/clusterrolebindings.yaml
kubectl apply -f backup/configmap-backstage-app-config.yaml
kubectl apply -f backup/service-backstage.yaml
kubectl apply -f backup/service-backstage-external.yaml
kubectl apply -f backup/deployment-backstage.yaml
```

### 3. Validar a Inicialização
```bash
kubectl rollout restart deployment backstage -n backstage
kubectl rollout status deployment backstage -n backstage --timeout=180s
curl -fsS -u admin:Backstage@2026 http://backstage.<dominio>/healthcheck
```
