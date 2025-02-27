module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = ">= 18.0.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnets         = var.subnets
  vpc_id          = var.vpc_id
  node_groups = var.node_groups
  tags = {
    Environment = "dev"
  }
}  