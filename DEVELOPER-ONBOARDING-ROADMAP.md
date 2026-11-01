# Roadmap & Guia de Onboarding do Desenvolvedor no Backstage

Bem-vindo à plataforma de engenharia de software corporativa! Este guia fornece o passo a passo completo para você, **desenvolvedor (DEV)**, fazer o onboarding da sua aplicação no **Backstage**, atender aos requisitos de observabilidade (logs e métricas), segurança de código (SonarQube) e colocar sua aplicação no ar no cluster **Amazon EKS** com **HTTPS** e **DNS dinâmico**.

---

## Sumário
1. [Visão Geral da Plataforma](#1-visão-geral-da-plataforma)
2. [Caminhos de Onboarding: Nova Aplicação vs. Aplicação Existente](#2-caminhos-de-onboarding)
   * [Opção A: Criar Nova Aplicação via Software Templates (Scaffolder)](#opção-a-criar-nova-aplicação-via-templates-recomendado)
   * [Opção B: Integrar um Repositório Existente](#opção-b-integrar-um-repositório-existente)
3. [Requisitos Mandatórios da Aplicação para Rodar no Ambiente](#3-requisitos-mandatórios-da-aplicação)
   * [3.1 Logs Estruturados em JSON (Fluentd -> Loki)](#31-padrão-de-logs-estruturados-em-json)
   * [3.2 Métricas de Telemetria (Prometheus & Grafana)](#32-exposição-de-métricas-para-o-prometheus)
   * [3.3 Health Checks e Probes de Saúde (Kubernetes)](#33-health-checks-liveness-e-readiness)
   * [3.4 Labels e Tags de Governança (FinOps & CNCF)](#34-labels-mandatórias-de-governança-e-finops)
   * [3.5 Qualidade e Segurança de Código (SonarQube Quality Gate)](#35-qualidade-de-código-e-sonarqube-quality-gate)
   * [3.6 Rede, DNS Dinâmico e Certificado HTTPS (Route 53 & ACM)](#36-rede-dns-dinâmico-e-https-acm)
4. [Anatomia Completa do `catalog-info.yaml`](#4-anatomia-completa-do-catalog-infoyaml)
5. [Checklist do Desenvolvedor (Definition of Done)](#5-checklist-do-desenvolvedor-definition-of-done)

---

## 1. Visão Geral da Plataforma

O **Backstage** é o seu Portal do Desenvolvedor (IDP). A partir dele, você tem acesso unificado a:
* **Catálogo de Software:** Visualização de todos os serviços, squads donas, APIs e dependências.
* **TechDocs:** Documentação técnica centralizada escrita em Markdown no próprio repositório.
* **Plugins de Observabilidade:** Dashboards do Grafana e métricas do Prometheus embebidos na página do seu componente.
* **Segurança e Qualidade:** Resultados de scans de segurança, bugs e cobertura de testes do SonarQube.
* **GitOps & Kubernetes:** Status em tempo real dos Pods no EKS e sincronismo via ArgoCD.

> **URLs de Acesso ao Ambiente:**
> * **Backstage:** `https://backstage.<lab-id>.realhandsonlabs.net` (ou `http://...`)
> * **Credenciais Padrão:** Usuário `admin` | Senha `Backstage@2026` (ou via login corporativo Keycloak SSO)
> * **SonarQube:** `https://sonarqube.<lab-id>.realhandsonlabs.net` (`admin` / `Sonar@2026`)
> * **Grafana:** `https://grafana.<lab-id>.realhandsonlabs.net` (`admin` / `Grafana@2026`)
> * **ArgoCD:** `https://argocd.<lab-id>.realhandsonlabs.net` (`admin`)

---

## 2. Caminhos de Onboarding

```mermaid
flowchart TD
    START([DEV quer rodar uma aplicação]) --> CHOICE{Criar nova ou integrar existente?}
    
    CHOICE -->|Nova Aplicação| TEMPLATE[Acessar Backstage -> Menu 'Create...']
    TEMPLATE --> SELECT_TPL[Escolher Template: Python, .NET, Spring Boot, Node.js ou Go]
    SELECT_TPL --> FILL_FORM[Preencher Nome, Squad, Repositório GitHub]
    FILL_FORM --> AUTO_GEN[Backstage cria Repo, CI/CD, K8s Manifests e Registra no Catálogo]
    
    CHOICE -->|Aplicação Existente| PREP_APP[Ajustar Aplicação aos Requisitos]
    PREP_APP --> ADD_LOGS[1. Adicionar Logs JSON]
    PREP_APP --> ADD_METRICS[2. Adicionar Rota /metrics]
    PREP_APP --> ADD_PROBES[3. Adicionar Probes /healthz e /ready]
    PREP_APP --> ADD_CATALOG[4. Criar catalog-info.yaml na raiz]
    ADD_CATALOG --> REGISTER[Backstage -> 'Register Existing Component']
    
    AUTO_GEN --> PUSH_CODE[Git Push / Commit na main]
    REGISTER --> PUSH_CODE
    
    PUSH_CODE --> GHA[GitHub Actions: Testes + SonarQube Quality Gate + Docker Build]
    GHA --> DEPLOY[Deploy no EKS + Registro DNS HTTPS no Route 53]
    DEPLOY --> LIVE[Aplicação Ativa em https://sua-app.realhandsonlabs.net]
```

### Opção A: Criar Nova Aplicação via Templates (Recomendado)
Se você está iniciando um novo microserviço, **use os Templates do Scaffolder**:
1. Acesse o Backstage e clique em **Create...** no menu lateral esquerdo.
2. Selecione o esqueleto da sua linguagem de preferência:
   * **Python 3.12 Flask:** Já vem com Gunicorn, testes com `pytest-cov`, `/metrics` e logs JSON.
   * **.NET 8 C# Web API:** Já vem com ASP.NET Core, OpenTelemetry, `/healthz` e xUnit.
   * **JVM Spring Boot:** Já vem com Spring Actuator, micrometer e logback JSON.
   * **Node.js Express:** Já vem com prom-client e Winston JSON logger.
   * **Go (Gin/Fiber):** Já vem com handlers de probe e métricas.
3. Preencha o formulário:
   * **Service Name:** Nome único em minúsculas (ex: `payment-service`).
   * **Responsible Team:** Nome da sua squad (ex: `squad-checkout`).
   * **Repository:** Selecione a organização e nome do repositório no GitHub.
4. Clique em **Create**. Em menos de 30 segundos, o Backstage gerará o repositório no GitHub com pipeline de CI/CD, testes, Dockerfile, manifests Kubernetes e registrará o componente automaticamente no catálogo!

---

### Opção B: Integrar um Repositório Existente
Se o seu repositório já existe:
1. Certifique-se de atender aos requisitos do [Capítulo 3](#3-requisitos-mandatórios-da-aplicação).
2. Adicione o arquivo `catalog-info.yaml` na raiz do seu repositório (modelo no [Capítulo 4](#4-anatomia-completa-do-catalog-infoyaml)).
3. No Backstage, vá em **Catalog** -> clique em **Register Existing Component**.
4. Cole a URL do arquivo no GitHub (ex: `https://github.com/cirodasilvaj/meu-repo/blob/main/catalog-info.yaml`).
5. Clique em **Analyze** e depois em **Import**.

---

## 3. Requisitos Mandatórios da Aplicação

Para que sua aplicação rode de forma estável, auditável e observável no cluster EKS da nossa infraestrutura, ela deve atender aos 6 requisitos abaixo:

### 3.1 Padrão de Logs Estruturados em JSON
No Kubernetes, logs **nunca** devem ser gravados em arquivos locais dentro do container. Eles devem ser emitidos para `stdout` (logs informativos) e `stderr` (erros), formatados em **JSON estruturado** para ingestão automática pelo **Fluentd** e indexação no **Loki**.

#### Campos Obrigatórios no JSON de Log:
```json
{
  "timestamp": "2026-11-01T12:00:00.123Z",
  "level": "INFO",
  "service": "payment-service",
  "message": "Ordem de pagamento processada com sucesso",
  "http_method": "POST",
  "endpoint": "/api/v1/payments",
  "status_code": 200,
  "duration_ms": 42.5,
  "client_ip": "10.0.10.45",
  "trace_id": "a1b2c3d4e5f6"
}
```

#### Exemplo em Python (Flask / Python 3.12):
```python
import logging
import json
from datetime import datetime
from flask import Flask, request

app = Flask(__name__)

class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            "timestamp": datetime.utcnow().isoformat() + "Z",
            "level": record.levelname,
            "service": "payment-service",
            "message": record.getMessage()
        }
        return json.dumps(log_entry)

handler = logging.StreamHandler()
handler.setFormatter(JsonFormatter())
app.logger.handlers = [handler]
app.logger.setLevel(logging.INFO)
```

#### Exemplo em .NET 8 (C# / `appsettings.json`):
```json
{
  "Logging": {
    "LogLevel": {
      "Default": "Information",
      "Microsoft.AspNetCore": "Warning"
    },
    "Console": {
      "FormatterName": "json",
      "FormatterOptions": {
        "TimestampFormat": "yyyy-MM-ddTHH:mm:ssZ"
      }
    }
  }
}
```

#### Anotações no Pod (`k8s/deployment.yaml`):
```yaml
spec:
  template:
    metadata:
      annotations:
        fluentd.io/collect: "true"
        fluentd.io/parser: "json"
        fluentd.io/destination: "loki"
```

---

### 3.2 Exposição de Métricas para o Prometheus
O cluster roda a stack Prometheus Community. Seu serviço deve expor a rota padrão `/metrics` no formato texto do Prometheus.

#### Exemplo em Python (`prometheus_client`):
```python
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from flask import Response

REQUEST_COUNT = Counter('http_requests_total', 'Total de requisições HTTP', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'Tempo de resposta em segundos', ['endpoint'])

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
```

#### Exemplo em .NET 8 (`Program.cs`):
```csharp
// Instalar pacote: dotnet add package prometheus-net.AspNetCore
using Prometheus;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseMetricServer(); // Expõe /metrics automaticamente
app.UseHttpMetrics();  // Coleta latência e taxas de requisição automáticas
app.Run();
```

#### Anotações no Pod para Auto-Scraping pelo Prometheus:
```yaml
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080" # Porta onde a sua aplicação escuta
        prometheus.io/path: "/metrics"
```

---

### 3.3 Health Checks (Liveness e Readiness)
O Kubernetes precisa saber quando sua aplicação está viva e quando ela pode receber tráfego de usuários:
* **Liveness Probe (`/healthz`):** Verifica se o processo está vivo. Se falhar, o Kubernetes reinicia o Pod.
* **Readiness Probe (`/ready`):** Verifica se a aplicação conectou ao banco de dados e dependências. Se falhar, o Pod para de receber tráfego até restabelecer.

#### Configuração no Deployment Kubernetes:
```yaml
readinessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 5
  periodSeconds: 10
livenessProbe:
  httpGet:
    path: /healthz
    port: 8080
  initialDelaySeconds: 15
  periodSeconds: 20
```

---

### 3.4 Labels Mandatórias de Governança e FinOps
Todo manifesto Kubernetes da sua aplicação (`Namespace`, `Deployment`, `Service`) **deve obrigatoriamente** conter as seguintes labels:

```yaml
metadata:
  labels:
    app.kubernetes.io/name: "payment-service"
    app.kubernetes.io/instance: "payment-service-prod"
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/component: "backend-api"
    app.kubernetes.io/part-of: "apps-demo-2026"
    app.kubernetes.io/managed-by: "argocd"
    app.kubernetes.io/created-by: "github-actions"
    environment: "sandbox"
    cost-center: "devops-platform-cloud"
    cloud-provider: "aws"
    source-project: "meu-repositorio"
    owner: "squad-checkout"
    backstage.io/kubernetes-id: "payment-service"
```

---

### 3.5 Qualidade de Código e SonarQube Quality Gate
Todo build no GitHub Actions deve passar pelo scanner do **SonarQube**. Se o Quality Gate falhar, o deploy **não será realizado**.

#### Arquivo `sonar-project.properties` (na raiz do repositório):
```properties
sonar.projectKey=squad-checkout:payment-service
sonar.projectName=Payment Service API
sonar.sources=src,app
sonar.tests=tests
sonar.sourceEncoding=UTF-8
sonar.python.coverage.reportPaths=coverage.xml
# Para .NET: sonar.cs.opencover.reportsPaths=**/coverage.opencover.xml
```

#### Requisitos do Quality Gate:
* **0** Vulnerabilidades Críticas ou Bloqueantes.
* **0** Security Hotspots não revisados.
* **>= 80%** de Cobertura de Código em testes unitários.
* Rating de Manutenibilidade **A** (baixo índice de código duplicado e code smells).

---

### 3.6 Rede, DNS Dinâmico e HTTPS (ACM)
1. **Service LoadBalancer:** O seu serviço no Kubernetes deve ser do tipo `LoadBalancer`.
2. **Delegação DNS:** O sincronizador do Route 53 associará seu LoadBalancer ao subdomínio:
   ```
   https://<nome-da-sua-app>.<lab-id>.realhandsonlabs.net
   ```
3. **Certificado HTTPS:** Um certificado Wildcard SSL/TLS (`*.<lab-id>.realhandsonlabs.net`) emitido pelo **AWS Certificate Manager (ACM)** está disponível. Para habilitar terminação HTTPS na porta 443:
   ```yaml
   metadata:
     annotations:
       service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:us-east-1:234824776462:certificate/xxxx"
       service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"
       service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
   ```

---

## 4. Anatomia Completa do `catalog-info.yaml`

Crie o arquivo `catalog-info.yaml` na raiz do seu repositório de código. Este é o arquivo que ensina o Backstage sobre o seu serviço:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: payment-service
  title: Payment Processing Service
  description: Microserviço responsável pelo processamento de transações de checkout e faturamento
  tags:
    - python
    - flask
    - payments
    - financial
  annotations:
    # Vincula o repositório GitHub para ver commits e pull requests
    github.com/project-slug: cirodasilvaj/payment-service
    
    # Vincula a documentação TechDocs escrita na pasta /docs do repositório
    backstage.io/techdocs-ref: dir:.
    
    # Vincula a análise de qualidade do SonarQube
    sonarqube.org/project-key: squad-checkout:payment-service
    
    # Vincula os pods no Kubernetes
    backstage.io/kubernetes-id: payment-service
    backstage.io/kubernetes-namespace: apps-demo
    
    # Vincula o alerta de métricas no Prometheus
    prometheus.io/rule: payment_service_http_requests_total
    
    # Vincula os dashboards do Grafana
    grafana/dashboard-selector: "app=payment-service"
    
    # Vincula a sincronização do GitOps
    argocd/app-name: payment-service

spec:
  type: service
  lifecycle: production
  owner: group:squad-checkout
  system: ecommerce-core
  providesApis:
    - payment-api
  dependsOn:
    - resource:default/postgres-database
```

---

## 5. Checklist do Desenvolvedor (Definition of Done)

Antes de considerar sua aplicação pronta para produção, valide cada item:

- [ ] **Templates:** A aplicação foi criada via Scaffolder ou possui Dockerfile multi-stage otimizado.
- [ ] **Logs:** A aplicação escreve logs em JSON diretamente no `stdout`/`stderr`.
- [ ] **Métricas:** A rota `/metrics` responde em formato Prometheus com anotações no Pod.
- [ ] **Health Checks:** Probes `/healthz` e `/ready` configuradas e funcionais.
- [ ] **Testes:** Testes unitários implementados e gerando relatório de cobertura de código.
- [ ] **SonarQube:** Scanner integrado no GitHub Actions passando com Quality Gate verde.
- [ ] **Catalog Info:** Arquivo `catalog-info.yaml` presente na raiz com todas as anotações.
- [ ] **TechDocs:** Pasta `docs/` com arquivo `mkdocs.yml` para geração de documentação técnica.
- [ ] **DNS & HTTPS:** Serviço acessível via `https://<app>.<lab-id>.realhandsonlabs.net`.
- [ ] **FinOps:** Labels `cost-center`, `environment` e `owner` preenchidas nos manifests.

---

> 💡 **Dúvidas ou Suporte?**  
> Procure a equipe de plataforma no Slack/Discord ou abra uma issue no repositório [`cirodasilvaj/backstage-infra`](https://github.com/cirodasilvaj/backstage-infra).
