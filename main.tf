# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_name        = var.vpc_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets
  cluster_name    = var.cluster_name
  region          = var.region

  tags = var.tags
}

# EKS Cluster Module
module "eks_cluster" {
  source = "./modules/eks-cluster"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  subnet_ids      = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  tags = var.tags
}

# EKS Node Group Module
module "eks_node_group" {
  source = "./modules/eks-node-group"

  cluster_name   = var.cluster_name
  subnet_ids     = module.vpc.private_subnets 
  desired_size   = var.desired_size
  max_size       = var.max_size
  min_size       = var.min_size
  instance_types = var.instance_types

  tags = var.tags

  depends_on = [module.eks_cluster]
}

# EKS Add-ons Module
module "eks_addons" {
  source = "./modules/eks-addons"

  cluster_name             = var.cluster_name
  cluster_version          = var.cluster_version
  ebs_csi_driver_role_arn  = module.eks_cluster.ebs_csi_driver_role_arn
  tags                     = var.tags

  depends_on = [
    module.eks_cluster,
    module.eks_node_group
  ]
}


# # EKS ALB Controller Module
# module "eks_alb_controller" {
#   source = "./modules/eks-alb-controller"

#   cluster_name      = var.cluster_name
#   region            = var.region
#   vpc_id            = module.vpc.vpc_id
#   oidc_provider_arn = module.eks_cluster.oidc_provider_arn
#   oidc_provider_url = module.eks_cluster.oidc_provider_url
#   tags              = var.tags

#   depends_on = [
#     module.eks_cluster,
#     module.eks_node_group
#   ]

#   providers = {
#     kubernetes = kubernetes
#   }

# }
