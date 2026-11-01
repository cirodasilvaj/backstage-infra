# Developer Onboarding Roadmap & Workflow Guide (Backstage IDP)

<div align="center">

[![Translate to Portuguese](https://img.shields.io/badge/Traduzir%20para-Portugu%C3%AAs-009c3b?style=for-the-badge&logo=google-translate&logoColor=white)](https://translate.google.com/translate?sl=en&tl=pt&u=https://github.com/cirodasilvaj/backstage-infra/blob/main/DEVELOPER-ONBOARDING-ROADMAP.md)
[![Backstage Version](https://img.shields.io/badge/Backstage-v1.30+-white?style=for-the-badge&logo=backstage&logoColor=blue)](https://backstage.io/)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-EKS%201.30-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://aws.amazon.com/eks/)
[![ArgoCD](https://img.shields.io/badge/GitOps-ArgoCD-orange?style=for-the-badge&logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![SonarQube](https://img.shields.io/badge/Security-SonarQube%20Quality%20Gate-4B9CD3?style=for-the-badge&logo=sonarqube&logoColor=white)](https://www.sonarqube.org/)

[ 🇺🇸 English Version (Active) ] &nbsp;|&nbsp; [ 🇧🇷 Versão em Português (Traduzida abaixo) ](#-versão-completa-em-português)

</div>

> 🌐 **Language Switcher / Alternador de Idioma:**  
> * **English (Default):** This document is officially written in English.  
> * **Português:** Click the **"Traduzir para Português"** badge above to translate via Google Translate, or scroll down to the [🇧🇷 Versão Completa em Português](#-versão-completa-em-português) section at the bottom for the native Portuguese version.

---

Welcome to our enterprise platform engineering ecosystem! This guide provides a deterministic, step-by-step walkthrough for **developers (DEVs)** to onboard applications into the **Backstage Internal Developer Portal (IDP)**, satisfy observability standards (JSON logging and Prometheus metrics), adhere to code quality and SAST security controls (SonarQube Quality Gate), and seamlessly deploy microservices to the **Amazon EKS cluster** with **dynamic Route 53 DNS**, **ACM HTTPS TLS termination**, and **GitOps automation (ArgoCD)**.

---

## Table of Contents
1. [Platform Overview & Access Endpoints](#1-platform-overview--access-endpoints)
2. [Developer Onboarding Paths: New Service vs. Existing Service](#2-developer-onboarding-paths)
   * [Option A: Create a New Service via Software Templates (Scaffolder - Recommended)](#option-a-create-a-new-service-via-software-templates-recommended)
   * [Option B: Integrate an Existing Git Repository](#option-b-integrate-an-existing-git-repository)
3. [Mandatory Application Production Readiness Requirements](#3-mandatory-application-production-readiness-requirements)
   * [3.1 Structured JSON Logging (Fluentd -> Loki)](#31-structured-json-logging-fluentd---loki)
   * [3.2 Prometheus Telemetry Metrics Exposition](#32-prometheus-telemetry-metrics-exposition)
   * [3.3 Health Checks and Kubernetes Probes (Liveness & Readiness)](#33-health-checks-and-kubernetes-probes)
   * [3.4 Mandatory Governance & FinOps Labels (CNCF Standards)](#34-mandatory-governance--finops-labels)
   * [3.5 Code Quality & SAST Security (SonarQube Quality Gate)](#35-code-quality--sast-security-sonarqube-quality-gate)
   * [3.6 Networking, Dynamic DNS & HTTPS (Route 53 & ACM)](#36-networking-dynamic-dns--https-acm)
   * [3.7 Observability Strategy: Minimizing Dashboards (Backstage Single Pane of Glass + Grafana Dashboard-as-Code)](#37-observability-strategy-minimizing-dashboards-backstage--grafana-dashboard-as-code)
4. [Complete Anatomy of `catalog-info.yaml`](#4-complete-anatomy-of-catalog-infoyaml)
5. [Complete Skeleton Directory Inventory](#5-complete-skeleton-directory-inventory)
6. [Developer Definition of Done (DoD) Checklist](#6-developer-definition-of-done-dod-checklist)
7. [🇧🇷 Versão Completa em Português](#-versão-completa-em-português)

---

## 1. Platform Overview & Access Endpoints

**Backstage** serves as your Internal Developer Portal (IDP). Through it, software engineers gain single-pane-of-glass access to:
* **Software Catalog:** Unified discovery of all services, squad ownership, APIs, and dependencies.
* **TechDocs:** Centralized technical documentation written in Markdown alongside your source code.
* **Observability Plugins:** Embedded Grafana dashboards and Prometheus metrics cards directly on your service entity page.
* **Security & Quality:** Live SonarQube SAST vulnerability scans, code smells, and unit test code coverage.
* **GitOps & Kubernetes:** Real-time pod lifecycle visibility on Amazon EKS synchronized via ArgoCD.

> **Platform Web UI Endpoints:**
> * **Backstage Portal:** `https://backstage.<lab-id>.realhandsonlabs.net` (or `http://...:7007`)
> * **SonarQube QA:** `https://sonarqube.<lab-id>.realhandsonlabs.net` (or `http://...:9000`)
> * **Grafana Observability:** `https://grafana.<lab-id>.realhandsonlabs.net` (or `http://...:3000`)
> * **ArgoCD GitOps:** `https://argocd.<lab-id>.realhandsonlabs.net` (or `http://...:8080`)
>
> 🔒 **Single Source of Truth for Platform Credentials (AWS SSM Parameter Store):**  
> In compliance with strict enterprise security governance, plaintext credentials are never stored in markdown files or printed into pipeline artifacts. All access credentials for developers and operators are consolidated and encrypted in a single AWS Systems Manager Parameter Store resource:
> * **Parameter Name:** `/kube-demo-2026/platform/credentials`
> * **Parameter ARN:** `arn:aws:ssm:us-east-1:<AWS_ACCOUNT_ID>:parameter/kube-demo-2026/platform/credentials`
> * **Type:** `SecureString` (AWS KMS Encrypted)
>
> **Command to retrieve credentials via AWS CLI:**
> ```bash
> aws ssm get-parameter \
>   --name "/kube-demo-2026/platform/credentials" \
>   --with-decryption \
>   --query "Parameter.Value" \
>   --output text | jq .
> ```

---

## 2. Developer Onboarding Paths

```mermaid
flowchart TD
    START([Developer wants to run a service]) --> CHOICE{New service or existing codebase?}
    
    CHOICE -->|New Service| TEMPLATE[Open Backstage -> Click 'Create...']
    TEMPLATE --> SELECT_TPL[Choose Software Template:\nPython, .NET, Spring Boot, Node.js, or Go]
    SELECT_TPL --> FILL_FORM[Fill in: Service Name, Squad, GitHub Repo]
    FILL_FORM --> AUTO_GEN[Backstage Scaffolder provisions:\nGit Repo, CI/CD, K8s Manifests, Grafana Dashboard & Catalog Entry]
    
    CHOICE -->|Existing Codebase| PREP_APP[Adapt Service to Platform Standards]
    PREP_APP --> ADD_LOGS[1. Add Structured JSON Logging]
    PREP_APP --> ADD_METRICS[2. Expose /metrics Endpoint]
    PREP_APP --> ADD_PROBES[3. Add /healthz Probes]
    PREP_APP --> ADD_CATALOG[4. Create catalog-info.yaml in root]
    ADD_CATALOG --> REGISTER[Backstage -> 'Register Existing Component']
    
    AUTO_GEN --> PUSH_CODE[Git Push / Merge to main]
    REGISTER --> PUSH_CODE
    
    PUSH_CODE --> GHA[GitHub Actions: Tests + SonarQube Quality Gate + Container Build + Grafana Provisioning]
    GHA --> ARGOCD[ArgoCD GitOps Sync to Amazon EKS]
    ARGOCD --> DEPLOY[Pod Running + Route 53 Dynamic DNS + ACM HTTPS]
    DEPLOY --> LIVE[Service Live at https://your-service.realhandsonlabs.net]
```

### Option A: Create a New Service via Software Templates (Recommended)

When scaffolding a brand-new microservice, **use the Backstage Scaffolder Templates**:
1. Log in to Backstage and click **Create...** on the left navigation sidebar.
2. Select your desired runtime skeleton:
   * **Python 3.12 Flask:** Comes preconfigured with Gunicorn, `pytest-cov`, `/metrics`, and Fluentd JSON logging.
   * **.NET 8 C# Web API:** Comes preconfigured with ASP.NET Core, OpenTelemetry, `/healthz`, and xUnit.
   * **JVM Spring Boot 3.3:** Comes preconfigured with Spring Actuator, Micrometer, Maven, and Logback JSON.
   * **Node.js 20 Express:** Comes preconfigured with `prom-client`, Winston JSON logging, and Jest.
   * **Microservice Core (Polyglot):** Standard cloud-native skeleton with health probes and telemetry.
3. Fill in the parameters:
   * **Service Name:** Unique kebab-case identifier (e.g., `payment-service`).
   * **Responsible Team:** Owning squad (e.g., `squad-checkout`).
   * **Git Destination:** Choose the GitHub organization and target repository name.
4. Click **Create**. In less than 30 seconds, Backstage provisions the entire repository with turnkey production readiness:
   * **Source Code:** Application boilerplate with `/metrics`, `/healthz`, and structured JSON logging for Fluentd/Loki.
   * **CI/CD Workflow (`.github/workflows/ci.yml`):** Runs unit tests, coverage reports, SonarQube scanning, Quality Gate enforcement, container image build & push to GitHub Container Registry (`ghcr.io`), and automatic Grafana dashboard provisioning via API.
   * **Dashboard-as-Code (`grafana/dashboard.json`):** Dedicated Grafana dashboard preconfigured with Golden Signals (RPS, 5xx Error %, p99 Latency, Uptime, Loki logs).
   * **GitOps ArgoCD (`k8s/argo-application.yaml`):** Declarative ArgoCD `Application` resource for automated continuous deployment.
   * **Kubernetes Manifests (`k8s/deployment.yaml` & `k8s/service-external.yaml`):** Deployment with FinOps/CNCF labels, ClusterIP internal Service, and LoadBalancer external Service with port 80 and 443 (ACM HTTPS).
   * **Dynamic DNS Script (`scripts/sync-dns-route53.sh`):** Automates Route 53 CNAME record creation bound to the EKS LoadBalancer.
   * **Backstage Catalog Entity (`catalog-info.yaml`):** Immediate catalog indexing linking GitHub, SonarQube, Kubernetes, and Grafana.

---

### Option B: Integrate an Existing Git Repository

If you have an existing application repository:
1. Verify that your service satisfies the [Mandatory Requirements in Section 3](#3-mandatory-application-production-readiness-requirements).
2. Add a `catalog-info.yaml` file to the root of your repository (following the schema in [Section 4](#4-complete-anatomy-of-catalog-infoyaml)).
3. In Backstage, open **Catalog** -> click **Register Existing Component**.
4. Paste the URL of your repository's `catalog-info.yaml` (e.g., `https://github.com/cirodasilvaj/my-repo/blob/main/catalog-info.yaml`).
5. Click **Analyze** and then **Import**.

---

## 3. Mandatory Application Production Readiness Requirements

To ensure stability, security, FinOps governance, and observability in the Amazon EKS cluster, all workloads must adhere to the 7 core requirements:

### 3.1 Structured JSON Logging (Fluentd -> Loki)
In Kubernetes, logs **must never** be written to local files inside containers. Applications must emit logs directly to `stdout` (informational) and `stderr` (errors) formatted as **structured JSON** for automated ingestion by the **Fluentd DaemonSet** and indexing in **Grafana Loki**.

#### Required JSON Log Schema:
```json
{
  "timestamp": "2026-11-01T12:00:00.123Z",
  "level": "INFO",
  "service": "payment-service",
  "message": "Payment transaction processed successfully",
  "http_method": "POST",
  "endpoint": "/api/v1/payments",
  "status_code": 200,
  "duration_ms": 42.5,
  "client_ip": "10.0.10.45",
  "trace_id": "a1b2c3d4e5f6"
}
```

#### Python 3.12 Example (Flask):
```python
import logging
import json
from datetime import datetime, timezone
from flask import Flask

app = Flask(__name__)

class JsonFormatter(logging.Formatter):
    def format(self, record):
        log_entry = {
            "timestamp": datetime.now(timezone.utc).isoformat(),
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

#### .NET 8 Example (C# `appsettings.json`):
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

#### Pod Metadata Annotations (`k8s/deployment.yaml`):
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

### 3.2 Prometheus Telemetry Metrics Exposition
The EKS cluster runs Prometheus Community (Helm v25.27.0). Services must expose `/metrics` in standard Prometheus text format.

#### Python Example (`prometheus_client`):
```python
from prometheus_client import Counter, Histogram, generate_latest, CONTENT_TYPE_LATEST
from flask import Response

REQUEST_COUNT = Counter('app_http_requests_total', 'Total HTTP requests', ['method', 'endpoint', 'status'])
REQUEST_LATENCY = Histogram('http_request_duration_seconds', 'HTTP request latency in seconds', ['endpoint'])

@app.route('/metrics')
def metrics():
    return Response(generate_latest(), mimetype=CONTENT_TYPE_LATEST)
```

#### .NET 8 Example (`Program.cs`):
```csharp
// Package: dotnet add package prometheus-net.AspNetCore
using Prometheus;

var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseMetricServer(); // Exposes /metrics automatically
app.UseHttpMetrics();  // Captures HTTP request rates and latencies automatically
app.Run();
```

#### Pod Auto-Scraping Annotations:
```yaml
spec:
  template:
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "8080"
        prometheus.io/path: "/metrics"
```

---

### 3.3 Health Checks and Kubernetes Probes
Kubernetes relies on probes to monitor container health and manage traffic routing:
* **Liveness Probe (`/healthz`):** Verifies the application process is alive. If this probe fails, Kubernetes restarts the pod.
* **Readiness Probe (`/ready` or `/healthz`):** Verifies the application is ready to accept user requests (database connections established, caches initialized). If this probe fails, the pod is removed from endpoints until healthy.

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
  initialDelaySeconds: 10
  periodSeconds: 15
```

---

### 3.4 Mandatory Governance & FinOps Labels
Every Kubernetes manifest (`Namespace`, `Deployment`, `Service`, `Ingress`) **must strictly include** the following enterprise metadata labels:

```yaml
metadata:
  labels:
    app.kubernetes.io/name: "payment-service"
    app.kubernetes.io/instance: "payment-service-prod"
    app.kubernetes.io/version: "1.0.0"
    app.kubernetes.io/component: "backend-api"
    app.kubernetes.io/part-of: "kube-demo-2026"
    app.kubernetes.io/managed-by: "argocd"
    app.kubernetes.io/created-by: "backstage-scaffolder"
    environment: "sandbox"
    cost-center: "devops-platform-cloud"
    cloud-provider: "aws"
    source-project: "payment-service"
    owner: "squad-checkout"
    backstage.io/kubernetes-id: "payment-service"
```

---

### 3.5 Code Quality & SAST Security (SonarQube Quality Gate)
Every CI execution on GitHub Actions triggers a SonarQube analysis. If the Quality Gate is not passed, deployment is blocked.

#### Configuration File `sonar-project.properties` (Repository Root):
```properties
sonar.projectKey=squad-checkout:payment-service
sonar.projectName=Payment Service API
sonar.sources=src,app
sonar.tests=tests
sonar.sourceEncoding=UTF-8
sonar.python.coverage.reportPaths=coverage.xml
# For .NET: sonar.cs.opencover.reportsPaths=**/coverage.opencover.xml
```

#### Quality Gate Criteria:
* **0** Critical or Blocker Vulnerabilities.
* **0** Unreviewed Security Hotspots.
* **>= 80%** Code Coverage on new code.
* Maintainability Rating **A** (low technical debt and duplication).

---

### 3.6 Networking, Dynamic DNS & HTTPS (ACM)
1. **Service LoadBalancer:** When external access is required, deploy an internet-facing Service or Ingress.
2. **Dynamic DNS Delegation:** The Route 53 synchronization script maps your LoadBalancer hostname to:
   ```
   https://<service-name>.<lab-id>.realhandsonlabs.net
   ```
3. **HTTPS TLS Termination:** An AWS Certificate Manager (ACM) Wildcard SSL certificate (`*.<lab-id>.realhandsonlabs.net`) is provisioned. To enable HTTPS termination on port 443:
   ```yaml
   metadata:
     annotations:
       service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:us-east-1:<ACCOUNT_ID>:certificate/<ID>"
       service.beta.kubernetes.io/aws-load-balancer-ssl-ports: "https"
       service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
   ```

---

### 3.7 Observability Strategy: Minimizing Dashboards (Backstage + Grafana Dashboard-as-Code)

#### Philosophy: "Single Pane of Glass" vs Dashboard Sprawl
To prevent metric fatigue and unmaintained panels, the platform enforces a strict separation of concerns:
* **Backstage (Developer Daily Driver):** Single Pane of Glass consolidating source code, TechDocs, Kubernetes pod health, and an embedded **Golden Signals Card** (Throughput/RPS, 5xx Error %, p99 Latency, and Loki live error logs).
* **Grafana (Deep Dive & Incident Diagnostics):** Underlying rendering engine. Developers click *"Open in Grafana"* from Backstage when they need to run ad-hoc PromQL/LogQL queries or timeline zoom.

```mermaid
flowchart TD
    DEV([Developer]) -->|Fills Scaffolder Form| SCAFFOLDER[Backstage Scaffolder]
    
    subgraph AUTO["Dashboard-as-Code Automation"]
        SCAFFOLDER -->|1. Renders App Code| REPO[Git Repository]
        SCAFFOLDER -->|2. Renders dashboard.json| DASH[dashboards/grafana-dashboard.json]
        SCAFFOLDER -->|3. Renders catalog-info.yaml| CAT[catalog-info.yaml with Grafana Tags]
    end
    
    REPO & DASH & CAT -->|Commit & Push| GIT[(GitHub / GitLab)]
    
    GIT -->|CI/CD Pipeline REST API or GitOps Sidecar| PROV[Dashboard Provisioner]
    PROV -->|Registers Dashboard| GRAFANA[(Grafana Engine)]
    
    GRAFANA -.->|Plugin API / Embedded View| BACKSTAGE[Backstage Portal / EntityPage]
    BACKSTAGE -->|Single Pane of Glass View| DEV
```

#### Skeleton Dashboard JSON Template (`grafana/dashboard.json`):
```json
{
  "overwrite": true,
  "dashboard": {
    "uid": "${{ values.component_id }}-dashboard",
    "title": "${{ values.component_id }} - Operational Overview",
    "tags": ["service:${{ values.component_id }}", "automated", "gold-signals"],
    "editable": false,
    "panels": [
      {
        "id": 1,
        "title": "Throughput / Request Rate (RPS)",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 },
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{app="${{ values.component_id }}"}[1m]))",
            "legendFormat": "RPS"
          }
        ]
      },
      {
        "id": 2,
        "title": "Error Rate (HTTP 5xx %)",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 12, "x": 12, "y": 0 },
        "targets": [
          {
            "expr": "sum(rate(http_requests_total{app="${{ values.component_id }}",status=~"5.."}[1m])) / sum(rate(http_requests_total{app="${{ values.component_id }}"}[1m])) * 100",
            "legendFormat": "5xx Error %"
          }
        ]
      },
      {
        "id": 3,
        "title": "Latency p99 (Milliseconds)",
        "type": "timeseries",
        "gridPos": { "h": 8, "w": 12, "x": 0, "y": 8 },
        "targets": [
          {
            "expr": "histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{app="${{ values.component_id }}"}[1m])) by (le)) * 1000",
            "legendFormat": "p99 (ms)"
          }
        ]
      },
      {
        "id": 4,
        "title": "Real-time Error Logs (Loki)",
        "type": "logs",
        "gridPos": { "h": 8, "w": 12, "x": 12, "y": 8 },
        "targets": [
          {
            "expr": "{app="${{ values.component_id }}"} |= "error"",
            "queryType": "range"
          }
        ]
      }
    ]
  }
}
```

---

## 4. Complete Anatomy of `catalog-info.yaml`

The `catalog-info.yaml` file residing in your repository's root teaches Backstage how to catalog, visualize, and monitor your service:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: payment-service
  title: Payment Processing Service
  description: Microservice handling payment checkout transactions and billing workflows
  tags:
    - python
    - flask
    - payments
    - financial
  annotations:
    # Links GitHub repository for commits, PRs, and contributors
    github.com/project-slug: cirodasilvaj/payment-service
    
    # Links TechDocs generated from the /docs folder
    backstage.io/techdocs-ref: dir:.
    
    # Links SonarQube SAST analysis and Quality Gate status
    sonarqube.org/project-key: squad-checkout:payment-service
    
    # Links Kubernetes Pods on Amazon EKS
    backstage.io/kubernetes-id: payment-service
    backstage.io/kubernetes-namespace: apps-demo
    
    # Links Prometheus metric alerts
    prometheus.io/rule: payment_service_http_requests_total
    
    # Links auto-provisioned Grafana dashboards
    grafana/dashboard-selector: "payment-service"
    grafana/tag-selector: "service:payment-service"
    
    # Links GitOps synchronization in ArgoCD
    argocd/app-name: payment-service

spec:
  type: service
  lifecycle: production
  owner: group:squad-checkout
  system: kube-demo-2026
  providesApis:
    - payment-api
  dependsOn:
    - resource:default/postgres-database
```

---

## 5. Complete Skeleton Directory Inventory

Every template in `backstage-infra/templates/` contains the full production skeleton:

| File Path | Purpose |
| :--- | :--- |
| `src/` / `app.py` / `Program.cs` | Application source code with `/metrics`, `/healthz`, and JSON logging. |
| `Dockerfile` | Multi-stage, minimal attack-surface container build. |
| `catalog-info.yaml` | Backstage component declaration with cross-plugin annotations. |
| `sonar-project.properties` | SonarQube scanner properties and test coverage paths. |
| `.github/workflows/ci.yml` | Full CI/CD: unit tests, SonarQube Quality Gate, GHCR container push, Grafana API dashboard provisioning. |
| `grafana/dashboard.json` | Dynamic Dashboard-as-Code JSON template with Golden Signals. |
| `k8s/deployment.yaml` | Kubernetes Deployment with CNCF/FinOps governance labels + internal ClusterIP Service. |
| `k8s/service-external.yaml` | External LoadBalancer Service with port 80 and 443 (ACM HTTPS SSL). |
| `k8s/argo-application.yaml` | Declarative ArgoCD GitOps Application manifest for continuous deployment. |
| `scripts/sync-dns-route53.sh` | Route 53 dynamic DNS registration script. |

---

## 6. Developer Definition of Done (DoD) Checklist

Before promoting your microservice to production, ensure every requirement is met:

- [ ] **Scaffolding:** Service created via Backstage Software Template or adheres to Dockerfile best practices.
- [ ] **Logging:** Logs emitted in structured JSON to `stdout`/`stderr` with pod metadata annotations.
- [ ] **Metrics:** Route `/metrics` operational and annotated for Prometheus scraping.
- [ ] **Health Checks:** Probes `/healthz` and `/ready` configured and responding HTTP 200.
- [ ] **Unit Tests:** Automated tests passing with >= 80% code coverage.
- [ ] **SonarQube:** Scanner passing with green Quality Gate (0 blockers, 0 security hotspots).
- [ ] **Container Image:** Container built and published to GitHub Container Registry (`ghcr.io`).
- [ ] **Catalog Entity:** `catalog-info.yaml` committed at repository root with all annotations.
- [ ] **TechDocs:** Directory `docs/` created with `mkdocs.yml` for technical documentation.
- [ ] **GitOps:** `argo-application.yaml` configured and synced in ArgoCD.
- [ ] **DNS & HTTPS:** Service accessible via `https://<service-name>.<lab-id>.realhandsonlabs.net`.
- [ ] **FinOps Governance:** Mandatory labels (`cost-center`, `environment`, `owner`) present on all K8s manifests.

---

> 💡 **Need Support or Guidance?**  
> Reach out to the Platform Engineering team via Slack/Discord or open an issue in the [`cirodasilvaj/backstage-infra`](https://github.com/cirodasilvaj/backstage-infra) repository.

---

## 7. 🇧🇷 Versão Completa em Português

<details>
<summary><b>👉 Clique aqui para expandir a documentação completa em Português (Brasil) / Click to expand full Portuguese documentation</b></summary>

<br/>

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
   * [3.7 Estratégia de Observabilidade: Mínimo de Dashboards (Backstage + Grafana Dashboard-as-Code)](#37-estratégia-de-observabilidade-mínimo-de-dashboards-backstage--grafana-dashboard-as-code)
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
> * **SonarQube:** `https://sonarqube.<lab-id>.realhandsonlabs.net`
> * **Grafana:** `https://grafana.<lab-id>.realhandsonlabs.net`
> * **ArgoCD:** `https://argocd.<lab-id>.realhandsonlabs.net`
>
> 🔒 **Credenciais Seguras no AWS Systems Manager (SSM) Parameter Store:**  
> Por conformidade de segurança corporativa, nenhuma senha é mantida em texto plano nas documentações. Todas as credenciais de acesso para desenvolvedores e administradores estão centralizadas e criptografadas no recurso único:
> * **Nome do Recurso no AWS Parameter Store:** `/kube-demo-2026/platform/credentials`
> * **ARN do Recurso:** `arn:aws:ssm:us-east-1:<AWS_ACCOUNT_ID>:parameter/kube-demo-2026/platform/credentials`
> * **Tipo:** `SecureString` (KMS Encrypted)
>
> **Comando para consultar suas credenciais via AWS CLI:**
> ```bash
> aws ssm get-parameter \
>   --name "/kube-demo-2026/platform/credentials" \
>   --with-decryption \
>   --query "Parameter.Value" \
>   --output text | jq .
> ```

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
4. Clique em **Create**. Em menos de 30 segundos, o Backstage gerará o repositório no GitHub com a estrutura completa e pronta para produção:
   * **Código-fonte:** App na linguagem escolhida com endpoints `/metrics`, `/healthz` e logs estruturados em JSON para Fluentd/Loki.
   * **Pipeline CI/CD (`.github/workflows/ci.yml`):** Executa testes unitários, cobertura, scanner do SonarQube, bloqueio por Quality Gate, build & push do container no GHCR e provisionamento automático do dashboard no Grafana via API.
   * **Dashboard-as-Code (`grafana/dashboard.json`):** Painel do Grafana com os *Golden Signals* da aplicação (Throughput/RPS, Taxa de Erros 5xx, Latência p99, Uptime e Logs do Loki).
   * **GitOps ArgoCD (`k8s/argo-application.yaml`):** Manifesto do ArgoCD para sincronização e deploy automatizado no EKS.
   * **Manifests Kubernetes (`k8s/deployment.yaml` e `k8s/service-external.yaml`):** Deployment com labels mandatórias de FinOps/CNCF, Service interno ClusterIP e Service LoadBalancer com portas 80 e 443 (HTTPS ACM).
   * **DNS Dinâmico (`scripts/sync-dns-route53.sh`):** Script para mapeamento CNAME automático no Route 53 com o hostname do LoadBalancer.
   * **Catálogo Backstage (`catalog-info.yaml`):** Registro imediato no catálogo do Backstage com todas as anotações (GitHub, SonarQube, Kubernetes e Grafana).

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

### 3.7 Estratégia de Observabilidade: Mínimo de Dashboards (Backstage + Grafana Dashboard-as-Code)

#### A Filosofia: "Single Pane of Glass" vs Sprawl de Dashboards
Na engenharia de software moderna, um dos maiores desafios operacionais é o **sprawl de dashboards** (centenas de dashboards dispersos, desatualizados e com métricas redundantes que ninguém mantém). 

A melhor prática adotada nesta plataforma é o padrão **Backstage como Single Pane of Glass + Grafana como Motor Operacional**:
* **No Backstage (Visão Diária do DEV):** O desenvolvedor encontra tudo consolidado na página do seu serviço no catálogo: código, documentação (*TechDocs*), status de pods no Kubernetes, e **cards/abas com os Golden Signals (Throughput/RPS, Taxa de Erros HTTP, Latência p99 e Logs de Erro no Loki)**. O DEV não precisa procurar ou navegar em pastas no Grafana para ver a saúde imediata da aplicação.
* **No Grafana (Visão Operacional / Debugging Avançado):** O Grafana permanece como o motor de renderização e análise profunda. Caso ocorra um incidente grave, o DEV clica em *"Abrir no Grafana"* diretamente pelo Backstage para acessar queries livres no Explore (PromQL/LogQL), correlações temporais e histogramas completos.

#### Arquitetura de Provisionamento: Dashboard-as-Code via Scaffolder
Ao criar a aplicação utilizando o **Software Template (Scaffolder)** do Backstage, o dashboard correspondente no Grafana é gerado e provisionado de forma **100% automatizada**, sem cliques manuais.

```mermaid
flowchart TD
    DEV([Desenvolvedor]) -->|Preenche formulário no Backstage| SCAFFOLDER[Backstage Scaffolder]
    
    subgraph AUTO["Automação Dashboard-as-Code"]
        SCAFFOLDER -->|1. Renderiza Código + skeleton| REPO[Repositório Git]
        SCAFFOLDER -->|2. Gera dashboard.json| DASH[dashboards/grafana-dashboard.json]
        SCAFFOLDER -->|3. Gera catalog-info.yaml| CAT[catalog-info.yaml com annotations]
    end
    
    REPO & DASH & CAT -->|Commit & Push| GIT[(GitHub / GitLab)]
    
    GIT -->|CI/CD Pipeline ou GitOps Operator| PROV[Provisionador de Dashboards]
    PROV -->|Cria via API ou ConfigMap| GRAFANA[(Grafana Server)]
    
    GRAFANA -.->|Consulta via Plugin API| BACKSTAGE[Backstage Portal / EntityPage]
    BACKSTAGE -->|Exibe Métricas e Logs na tela do DEV| DEV
```

---

#### 1. Definição do Template no Backstage (`template.yaml`)
O template do Scaffolder captura o identificador do serviço e orquestra a renderização dos manifests e do dashboard:

```yaml
apiVersion: scaffolder.backstage.io/v1beta3
kind: Template
metadata:
  name: standard-microservice-template
  title: Microserviço com Dashboard Grafana Automático
  description: Cria repositório, provisiona dashboard no Grafana e registra no catálogo
spec:
  owner: platform-team
  type: service
  parameters:
    - title: Detalhes do Serviço
      required:
        - component_id
        - owner
      properties:
        component_id:
          title: Nome do Serviço
          type: string
          description: Identificador kebab-case (ex: payment-service)
        owner:
          title: Time Responsável
          type: string
          description: Entidade do grupo no Backstage (ex: squad-checkout)
  steps:
    - id: fetch-base
      name: Renderizando templates de código e observabilidade
      action: fetch:template
      input:
        url: ./skeleton
        values:
          component_id: ${{ parameters.component_id }}
          owner: ${{ parameters.owner }}

    - id: publish-repo
      name: Criando repositório no GitHub
      action: publish:github
      input:
        repoUrl: github.com?repo=${{ parameters.component_id }}&owner=cirodasilvaj
        defaultBranch: main

    - id: register-catalog
      name: Registrando componente no Backstage
      action: catalog:register
      input:
        repoContentsUrl: ${{ steps['publish-repo'].output.repoContentsUrl }}
        catalogInfoPath: '/catalog-info.yaml'
```

---

#### 2. Arquivos no diretório `skeleton/` do Template

##### A. `catalog-info.yaml` (Renderizado com as Anotações do Grafana)
As anotações vinculam a entidade do Backstage às tags e dashboards correspondentes:

```yaml
apiVersion: backstage.io/v1alpha1
kind: Component
metadata:
  name: ${{ values.component_id }}
  annotations:
    # Vincula o dashboard criado automaticamente ao serviço no Backstage
    grafana/dashboard-selector: ${{ values.component_id }}
    grafana/tag-selector: 'service:${{ values.component_id }}'
    backstage.io/source-location: url:https://github.com/cirodasilvaj/${{ values.component_id }}
    backstage.io/techdocs-ref: dir:.
spec:
  type: service
  lifecycle: production
  owner: ${{ values.owner }}
```

##### B. `dashboards/grafana-dashboard.json` (Template JSON Jinja/Nunjucks)
O arquivo de dashboard foca exclusivamente nos **Golden Signals essenciais** para evitar excesso de métricas:

```json
{
  "title": "${{ values.component_id }} - Visão Operacional",
  "uid": "${{ values.component_id }}-dashboard",
  "tags": ["service:${{ values.component_id }}", "automated", "gold-signals"],
  "editable": false,
  "panels": [
    {
      "id": 1,
      "title": "Throughput / Taxa de Requisições (RPS)",
      "type": "timeseries",
      "gridPos": { "h": 8, "w": 12, "x": 0, "y": 0 },
      "targets": [
        {
          "expr": "sum(rate(http_requests_total{app=\"${{ values.component_id }}\"}[1m]))",
          "legendFormat": "RPS"
        }
      ]
    },
    {
      "id": 2,
      "title": "Taxa de Erros HTTP (4xx / 5xx)",
      "type": "timeseries",
      "gridPos": { "h": 8, "w": 12, "x": 12, "y": 0 },
      "targets": [
        {
          "expr": "sum(rate(http_requests_total{app=\"${{ values.component_id }}\",status=~\"5..\"}[1m])) / sum(rate(http_requests_total{app=\"${{ values.component_id }}\"}[1m])) * 100",
          "legendFormat": "5xx Error %"
        }
      ]
    },
    {
      "id": 3,
      "title": "Latência p99 (Milissegundos)",
      "type": "timeseries",
      "gridPos": { "h": 8, "w": 12, "x": 0, "y": 8 },
      "targets": [
        {
          "expr": "histogram_quantile(0.99, sum(rate(http_request_duration_seconds_bucket{app=\"${{ values.component_id }}\"}[1m])) by (le)) * 1000",
          "legendFormat": "p99 (ms)"
        }
      ]
    },
    {
      "id": 4,
      "title": "Logs de Erro em Tempo Real (Loki)",
      "type": "logs",
      "gridPos": { "h": 8, "w": 12, "x": 12, "y": 8 },
      "targets": [
        {
          "expr": "{app=\"${{ values.component_id }}\"} |= \"error\"",
          "queryType": "range"
        }
      ]
    }
  ]
}
```

---

#### 3. Automação do Provisionamento no Grafana
Para carregar o dashboard no Grafana de maneira 100% automatizada:

* **Opção 1 — Via CI/CD Pipeline (GitHub Actions):**
  No workflow de CI da aplicação gerada pelo Scaffolder, execute o step de publicação:
  ```yaml
  - name: Provisionar Dashboard no Grafana
    env:
      GRAFANA_URL: "https://grafana.realhandsonlabs.net"
      GRAFANA_TOKEN: ${{ secrets.GRAFANA_API_TOKEN }}
    run: |
      curl -X POST \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer ${GRAFANA_TOKEN}" \
        -d @dashboards/grafana-dashboard.json \
        "${GRAFANA_URL}/api/dashboards/db"
  ```

* **Opção 2 — Via Kubernetes ConfigMap / GitOps (Grafana Sidecar / Operator):**
  O Scaffolder gera um manifesto K8s `grafana-dashboard-configmap.yaml` com o label de auto-descoberta:
  ```yaml
  apiVersion: v1
  kind: ConfigMap
  metadata:
    name: ${{ values.component_id }}-dashboard
    namespace: monitoring
    labels:
      grafana_dashboard: "1"
  data:
    ${{ values.component_id }}.json: |-
      # Conteúdo do dashboard JSON
  ```
  O sidecar do Grafana detecta o ConfigMap e o dashboard aparece instantaneamente na interface.

---

#### 4. Integração no Backstage (`app-config.yaml` & `EntityPage.tsx`)

* **Configuração do Plugin no `app-config.yaml`:**
  ```yaml
  grafana:
    domain: https://grafana.realhandsonlabs.net
    apiToken: ${GRAFANA_API_TOKEN}
  ```
  > 🔒 **Nota de Segurança:** As credenciais e API tokens do Grafana são obtidos dinamicamente a partir do AWS SSM Parameter Store:  
  > `arn:aws:ssm:us-east-1:<AWS_ACCOUNT_ID>:parameter/kube-demo-2026/platform/credentials`.

* **Renderização na Interface do Backstage (`EntityPage.tsx`):**
  Utilizando o pacote `@k-phoen/backstage-plugin-grafana`:
  ```tsx
  import { EntityGrafanaDashboardsCard, isGrafanaAvailable } from '@k-phoen/backstage-plugin-grafana';

  // Card resumido na aba Overview
  const overviewContent = (
    <Grid container spacing={3} alignItems="stretch">
      <EntitySwitch>
        <EntitySwitch.Case if={isGrafanaAvailable}>
          <Grid item md={6} xs={12}>
            <EntityGrafanaDashboardsCard />
          </Grid>
        </EntitySwitch.Case>
      </EntitySwitch>
    </Grid>
  );

  // Aba dedicada 'Grafana' na entidade do componente
  const serviceEntityPage = (
    <EntityLayout>
      <EntityLayout.Route path="/" title="Overview">
        {overviewContent}
      </EntityLayout.Route>
      <EntityLayout.Route path="/grafana" title="Grafana" if={isGrafanaAvailable}>
        <EntityGrafanaDashboardsCard />
      </EntityLayout.Route>
      <EntityLayout.Route path="/docs" title="Docs">
        <EntityTechdocsContent />
      </EntityLayout.Route>
    </EntityLayout>
  );
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
    grafana/dashboard-selector: "payment-service"
    grafana/tag-selector: "service:payment-service"
    
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

</details>
