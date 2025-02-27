// main.tf
terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }

  // VPC Module
module "vpc" {
  source               = "./modules/vpc"
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
  aws_region           = var.aws_region
}
// EKS Module (using a well-known module from the Terraform Registry)
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = ">= 18.0.0"
  cluster_name    = var.cluster_name
  cluster_version = "1.24"
  subnets         = module.vpc.private_subnet_ids
  vpc_id          = module.vpc.vpc_id
  node_groups = {
    default = {
      desired_capacity = 2
      max_capacity     = 3
      min_capacity     = 1
      instance_type    = "t3.medium"
      subnets          = module.vpc.private_subnet_ids
    }
  }
}
// RDS Module for PostgreSQL
module "rds" {
  source             = "./modules/rds"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  db_username        = var.db_username
  db_password        = var.db_password
  db_name            = var.db_name
  aws_region         = var.aws_region
}
// Deploy cert-manager via Helm
resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.9.1"
  namespace  = "cert-manager"
  create_namespace = true
  set {
    name  = "installCRDs"
    value = "true"
  }
}
// Create a ClusterIssuer for Let's Encrypt (for automatic TLS certs)
resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = {
    "apiVersion" = "cert-manager.io/v1"
    "kind"       = "ClusterIssuer"
    "metadata" = {
      "name" = "letsencrypt-prod"
    }
    "spec" = {
      "acme" = {
        "email"         = "your-email@example.com"  // Replace with your email
        "server"        = "https://acme-v02.api.letsencrypt.org/directory"
        "privateKeySecretRef" = {
          "name" = "letsencrypt-prod"
        }
        "solvers" = [
          {
            "dns01" = {
              "route53" = {
                "region" = var.aws_region
                // Optionally, you can specify hosted zone details here.
              }
            }
          }
        ]
      }
    }
  }
  depends_on = [helm_release.cert_manager]
}
// Deploy ingress-nginx via Helm
resource "helm_release" "ingress_nginx" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.7.0"
  namespace  = "ingress-nginx"
  create_namespace = true
  values = [file("${path.module}/helm/ingress-nginx-values.yaml")]
}
// Deploy SonarQube via Helm
resource "helm_release" "sonarqube" {
  name       = "sonarqube"
  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  version    = "9.6.0"
  namespace  = "sonarqube"
  create_namespace = true
  values = [file("${path.module}/helm/sonarqube-values.yaml")]
}
// Deploy ArgoCD via Helm with ingress exposure
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "4.10.2"
  namespace  = "argocd"
  create_namespace = true
  values = [file("${path.module}/helm/argocd-values.yaml")]
}