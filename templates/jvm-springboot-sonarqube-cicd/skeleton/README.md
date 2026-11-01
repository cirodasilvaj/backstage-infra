# ${{ values.component_id }} (JVM Spring Boot 3.3 / Java 21)

${{ values.description }}

- **Stack**: Java 21 (Eclipse Temurin) + Spring Boot 3.3 + Maven + JaCoCo
- **CI/CD & SonarQube Quality Gate**: `.github/workflows/ci.yml` (`projectKey: ${{ values.component_id }}`, SpotBugs/FindSecBugs + OWASP Dependency-Check)
- **Prometheus Metrics**: `GET /metrics` (`app_http_requests_total`, `app_uptime_seconds`)
- **Fluentd -> Grafana Loki Logs**: Structured JSON logs forwarded via `fluentd.logging.svc.cluster.local:24224` -> `loki.grafana.svc.cluster.local:3100`
