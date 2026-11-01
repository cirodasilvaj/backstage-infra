# ${{ values.component_id }}

${{ values.description }}

- **CI/CD & SonarQube Quality Gate**: `.github/workflows/ci.yml` (`projectKey: ${{ values.component_id }}`)
- **Prometheus Metrics**: `GET /metrics` (`app_http_requests_total`, `app_uptime_seconds`)
- **Fluentd -> Grafana Loki Logs**: Structured JSON logs forwarded to `fluentd.logging.svc.cluster.local:24224` -> `loki.grafana.svc.cluster.local:3100`
