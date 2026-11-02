# Backstage Configuration & State Backup

Este diretório contém o backup completo das configurações ativas, banco de dados e manifestos Kubernetes do **Backstage Developer Portal**.

---

## Conteúdo do Diretório

| Arquivo | Descrição |
| :--- | :--- |
| `backstage-rds-dump.sql` | Dump SQL completo do AWS RDS PostgreSQL 16 (tabelas `knex_migrations`, `final_entities`, `refresh_state`, etc.). |
| `app-config.production.yaml` | Arquivo `app-config.yaml` ativo com integrações GitHub (`cirodasilvaj`), discovery processor e banco RDS. |
| `catalog-entities.yaml` | Entidades estáticas base (usuário `guest` e squad `platform-team`). |
| `configmap-backstage-app-config.yaml` | Manifest do ConfigMap Kubernetes contendo os arquivos de configuração do Backstage. |
| `deployment-backstage.yaml` | Manifest do Deployment Kubernetes com os 3 containers (`backstage-auth-proxy`, `backstage-db-sync`, `backstage`). |
| `service-backstage.yaml` | Manifest do Service Kubernetes (ClusterIP e LoadBalancer com SSL). |
| `rbac-backstage.yaml` | Manifest RBAC consolidado (ServiceAccount, Secret token, ClusterRoles e ClusterRoleBindings). |
| `secrets-template.yaml` | Template declarativo dos Secrets necessários (`backstage-db-credentials`, `backstage-github-credentials`, etc.). |
| `k8s-cluster-status.json` | Snapshot do status de conectividade e contagem de recursos do cluster EKS. |

---

## Como Restaurar a partir deste Diretório

### Método Automatizado (Recomendado)
Execute o script oficial de restauração completa com validação e smoke tests:
```bash
./scripts/restore-backstage.sh
```

### Método Manual Passo a Passo
1. **Restaurar o Banco de Dados no RDS:**
   ```bash
   kubectl exec -i -n backstage deployment/backstage -c backstage-db-sync -- sh -c \
     'PGPASSWORD="$POSTGRES_PASSWORD" psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -U "$POSTGRES_USER" -d "$POSTGRES_DB"' \
     < backup/backstage-rds-dump.sql
   ```

2. **Aplicar os Manifestos de Configuração:**
   ```bash
   kubectl apply -f backup/rbac-backstage.yaml
   kubectl apply -f backup/configmap-backstage-app-config.yaml
   kubectl apply -f backup/service-backstage.yaml
   kubectl apply -f backup/deployment-backstage.yaml
   ```

3. **Reiniciar e Validar o Rollout:**
   ```bash
   kubectl rollout restart deployment backstage -n backstage
   kubectl rollout status deployment backstage -n backstage --timeout=180s
   curl -fsS -u admin:Backstage@2026 http://backstage.799416476486.realhandsonlabs.net/healthcheck
   ```
