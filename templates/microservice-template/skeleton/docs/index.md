# ${{ values.component_id }}

${{ values.description }}

## Production Readiness Standards

This service is scaffolded in compliance with the **Backstage IDP Platform Engineering Standards**:

- **Structured JSON Logging:** Emitted to `stdout` and collected by Fluentd into Grafana Loki.
- **Prometheus Telemetry:** Golden Signals exported at `/metrics`.
- **Health Probes:** Kubernetes Liveness (`/healthz`) and Readiness (`/ready`) endpoints.
- **SonarQube Quality Gate:** Continuous static analysis on every pull request.
- **Continuous Delivery:** Automated deployment via ArgoCD on Amazon EKS.
