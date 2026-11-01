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

  default_tags {
    tags = {
      Project           = "backstage-infra"
      SourceProject     = "backstage-infra"
      Environment       = "sandbox"
      ManagedBy         = "terraform"
      ResourceGenerator = "terraform"
      CostCenter        = "devops-platform-cloud"
      CloudProvider     = "aws"
      Owner             = "platform-team"
      Repository        = "https://github.com/cirodasilvaj/backstage-infra"
      Lifecycle         = "ephemeral-7h"
      Provisioner       = "github-actions"
    }
  }
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

data "aws_vpc" "target" {
  id = data.aws_eks_cluster.target.vpc_config[0].vpc_id
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
