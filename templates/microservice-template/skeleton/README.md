# ${{ values.component_id }}

${{ values.description }}

## Architecture & Observability Features

- **CI/CD & Quality Gate**: Automated GitHub Actions workflow (`.github/workflows/ci.yml`) running **SonarQube Scanner** and **SonarQube Quality Gate** (`projectKey: ${{ values.component_id }}`).
- **Prometheus Metrics (`/metrics`)**: Exposes `app_http_requests_total` and `app_uptime_seconds` scraped automatically by Prometheus (`http://prometheus-server.monitoring.svc.cluster.local`) and visualized in **Grafana**.
- **Fluentd -> Grafana Loki Logging**: Emits structured JSON logs shipped by **Fluentd** (`fluentd.logging.svc.cluster.local:24224`) into **Grafana Loki** (`http://loki.grafana.svc.cluster.local:3100`).
- **Kubernetes GitOps**: Ready-to-deploy manifest in `k8s/deployment.yaml` linked to Backstage via `backstage.io/kubernetes-id: ${{ values.component_id }}`.

## Endpoints

- `GET /` — Service metadata (`language`, `version`, `client_ip`, `hostname`)
- `GET /api/info` — JSON metadata payload
- `GET /metrics` — Prometheus metrics exposition
- `GET /healthz` — Kubernetes readiness/liveness probe
