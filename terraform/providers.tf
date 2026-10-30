terraform {
  required_version = ">= 1.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Points at the EKS cluster already provisioned by the kube-demo-2026 repo
# (terraform/eks module there). This repo never creates or modifies the
# cluster itself, only what runs on top of it.
data "aws_eks_cluster" "target" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "target" {
  name = var.eks_cluster_name
}

# Same cross-repo pattern as the cluster above: the Fluentd IRSA role is
# created in kube-demo-2026/eks (where the cluster's OIDC provider lives),
# named "${eks_cluster_name}-fluentd-role". Looked up by name, same AWS
# account/region as the cluster.
data "aws_iam_role" "fluentd" {
  name = "${var.eks_cluster_name}-fluentd-role"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.target.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.target.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.target.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.target.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.target.token
  }
}
