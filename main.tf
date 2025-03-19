terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"  # Allows latest 4.x version
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"  # Allows latest 2.x version
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"  # Allows latest 2.x version
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"  # Change this to your desired region
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_name        = "my-vpc"
  vpc_cidr        = "10.0.0.0/16"
  azs             = ["ap-southeast-1a", "ap-southeast-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
  cluster_name    = "my-eks-cluster"

  tags = {
    environment = "UAT"
    project     = "MyEKS"
    owner       = "Hello-World"
  }
}

# EKS Cluster Module
module "eks_cluster" {
  source = "./modules/eks-cluster"

  cluster_name = "my-eks-cluster"
  subnet_ids   = concat(module.vpc.private_subnets, module.vpc.public_subnets)

  tags = {
    environment = "UAT"
    project     = "MyEKS"
    owner       = "Hello-World"
  }
}

# EKS Node Group Module
module "eks_node_group" {
  source = "./modules/eks-node-group"

  cluster_name   = module.eks_cluster.cluster_name
  subnet_ids     = module.vpc.private_subnets
  desired_size   = 2
  max_size       = 3
  min_size       = 1
  instance_types = ["t3.medium"]

  tags = {
    environment = "UAT"
    project     = "MyEKS"
    owner       = "Hello-World"
  }
}

# Kubernetes Provider Configuration
provider "kubernetes" {
  host                   = module.eks_cluster.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
  }
}

# Helm Provider Configuration
provider "helm" {
  kubernetes {
    host                   = module.eks_cluster.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_cluster.cluster_ca_certificate)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks_cluster.cluster_name]
    }
  }
}

# Outputs
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  description = "Endpoint of the EKS cluster"
  value       = module.eks_cluster.cluster_endpoint
}