# backstate-infra

Backstage.io + ArgoCD on top of the EKS cluster already provisioned by
[`kube-demo-2026`](https://github.com/cirobessa/kube-demo-2026) (the
`eks/` module there — cluster name `kube-demo-eks`, region `us-east-1`).

This repo never touches the cluster itself: it only installs workloads on
top of it.

## How it fits together

1. `terraform/modules/argocd` installs ArgoCD into the cluster via the
   official `argo-cd` Helm chart.
2. `terraform/modules/backstage-app` creates one ArgoCD `Application`
   resource (rendered from `k8s-manifests/argo/application-backstage.yaml`)
   that points ArgoCD at `k8s-manifests/backstage` in this same repo.
3. `terraform/modules/monitoring-app` creates a second ArgoCD `Application`
   (rendered from `k8s-manifests/argo/application-monitoring.yaml`) that
   points at the upstream `kube-prometheus-stack` Helm chart — standard
   Prometheus + Alertmanager + Grafana observability for the cluster,
   which didn't exist anywhere before.
4. `terraform/modules/logging-app` creates a third ArgoCD `Application`
   (rendered from `k8s-manifests/argo/application-logging.yaml`) that
   points at the upstream `fluentd` chart, overriding only its output
   stage to ship container logs to CloudWatch Logs
   (`/eks/<cluster-name>/containers`) via the Fluentd IRSA role created in
   `kube-demo-2026/eks` (`eks/irsa.tf`, looked up here by name). Log
   aggregation didn't exist anywhere before either.
5. From there on, **ArgoCD owns all three**: any change pushed to
   `k8s-manifests/backstage/**` on `main` gets auto-synced into the
   `backstage` namespace, and `kube-prometheus-stack`/`fluentd` are kept in
   sync into the `monitoring`/`logging` namespaces (`prune: true`,
   `selfHeal: true` for all). Terraform is only used once, to bootstrap
   ArgoCD and register the Applications — it does not manage the
   workloads directly.

```
terraform/                   bootstraps ArgoCD + registers the apps
  main.tf, variables.tf, outputs.tf, providers.tf, backend.tf
  modules/argocd/            Helm install of ArgoCD
  modules/backstage-app/     ArgoCD Application CR for Backstage
  modules/monitoring-app/    ArgoCD Application CR for kube-prometheus-stack
  modules/logging-app/       ArgoCD Application CR for fluentd

k8s-manifests/
  argo/application-backstage.yaml    template rendered by modules/backstage-app
  argo/application-monitoring.yaml   template rendered by modules/monitoring-app
  argo/application-logging.yaml      template rendered by modules/logging-app
  backstage/                         what ArgoCD actually deploys (edit this to change Backstage)
```

## Prerequisites

- An EKS cluster already up (`kube-demo-2026/eks`), with `kube-demo-eks`
  as its name in `us-east-1` — override via `-var eks_cluster_name=...
  -var aws_region=...` if yours differs.
- Terraform >= 1.5, AWS CLI v2, `kubectl`.
- `AWS_ACCESS_KEY_ID` / `AWS_SECRET_ACCESS_KEY` with permission to read the
  EKS cluster and to create/read the Terraform state bucket. In CI these
  are **already set as repo secrets** (Settings → Secrets and variables →
  Actions) — the workflow only references `secrets.AWS_ACCESS_KEY_ID` /
  `secrets.AWS_SECRET_ACCESS_KEY`, it never contains the values.
- A real Backstage app image before Backstage will actually come up
  healthy — see "Build a Backstage image" below. Backstage has no generic
  public image; every installation scaffolds and builds its own.

## 1. Deploy (local)

```bash
cd terraform
terraform init \
  -backend-config="bucket=backstate-infra-tfstate-<your-account-id>" \
  -backend-config="key=backstate-infra/terraform.tfstate" \
  -backend-config="region=us-east-1" \
  -backend-config="use_lockfile=true"
terraform apply
```

Or via GitHub Actions: `.github/workflows/terraform.yml`
(`workflow_dispatch`, pick `plan`/`apply`/`destroy`) — it creates the state
bucket on first run, the same way `kube-demo-2026` does.

## 2. Reach ArgoCD

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath='{.data.password}' | base64 -d
kubectl -n argocd port-forward svc/argocd-server 8080:443
# https://localhost:8080 — user: admin
```

Check the `backstage` Application there; it should show `OutOfSync` /
`Degraded` until a real image is set (see below), then `Synced` /
`Healthy`.

## 3. Build a Backstage image

```bash
npx @backstage/create-app@latest
cd <your-app-name>
yarn build:backend --build-dependencies
docker build . -f packages/backend/Dockerfile -t <your-registry>/backstage-app:latest
docker push <your-registry>/backstage-app:latest
```

Then edit `k8s-manifests/backstage/deployment.yaml`, set `image:` to that
tag, and push to `main`. ArgoCD picks it up and rolls it out — no
Terraform run needed for that step.

## 4. Reach Backstage

```bash
kubectl -n backstage port-forward svc/backstage 7007:7007
# http://localhost:7007
```

## 5. Reach Grafana / Prometheus

```bash
kubectl -n monitoring get secret monitoring-grafana \
  -o jsonpath='{.data.admin-password}' | base64 -d
kubectl -n monitoring port-forward svc/monitoring-grafana 3000:80
# http://localhost:3000 — user: admin
```

Prometheus and Alertmanager are also reachable in-cluster at
`monitoring-kube-prometheus-prometheus:9090` and
`monitoring-kube-prometheus-alertmanager:9093`.

## 6. Reach the logs

```bash
aws logs tail /eks/kube-demo-eks/containers --follow --region us-east-1
```

Requires the Fluentd IRSA role (`kube-demo-eks-fluentd-role`, created by
`kube-demo-2026/eks`) to already exist — `terraform apply` here fails at
`data.aws_iam_role.fluentd` if that role hasn't been created yet.

## Notes / limitations

- `k8s-manifests/backstage/configmap-app-config.yaml` ships
  `better-sqlite3` (`:memory:`) — fine for a demo, data is lost on pod
  restart. Swap in a Postgres `app-config.production.yaml` for anything
  that needs to persist.
- ArgoCD's server runs with `server.service.type=ClusterIP` and
  `server.insecure=true` for the demo (plain HTTP behind `port-forward`).
  Put a real Ingress/ALB + TLS in front of it for anything beyond a demo.
- Never commit `*.tfvars` or `.terraform/` — `.gitignore` enforces this,
  and AWS credentials only ever come from the GitHub Actions secrets
  already configured on this repo, never from committed files.
