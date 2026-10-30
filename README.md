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
3. From there on, **ArgoCD owns Backstage**: any change pushed to
   `k8s-manifests/backstage/**` on `main` gets auto-synced into the
   `backstage` namespace (`prune: true`, `selfHeal: true`). Terraform is
   only used once, to bootstrap ArgoCD and register the Application — it
   does not manage the Backstage Deployment/Service directly.

```
terraform/                   bootstraps ArgoCD + registers the app
  main.tf, variables.tf, outputs.tf, providers.tf, backend.tf
  modules/argocd/            Helm install of ArgoCD
  modules/backstage-app/     ArgoCD Application CR for Backstage

k8s-manifests/
  argo/application-backstage.yaml   template rendered by modules/backstage-app
  backstage/                        what ArgoCD actually deploys (edit this to change Backstage)
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
