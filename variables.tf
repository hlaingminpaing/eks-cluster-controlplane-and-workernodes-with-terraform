variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "uat-eks-cluster"  # Optional default value
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.32"  # Optional default value
}

variable "region" {
  description = "AWS region for the deployment"
  type        = string
  default     = "ap-southeast-1"  # Optional default value
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "uat-vpc"  # Set a default or provide a value in tfvars
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "Availability zones"
  type        = list(string)
  default     = ["ap-southeast-1a", "ap-southeast-1b"]
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "desired_size" {
  description = "Desired number of worker nodes"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of worker nodes"
  type        = number
  default     = 3
}

variable "min_size" {
  description = "Minimum number of worker nodes"
  type        = number
  default     = 1
}

variable "instance_types" {
  description = "List of instance types for the node group"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "tags" {
  description = "A map of tags to apply to all resources"
  type        = map(string)
  default = {
    environment = "UAT"
    project     = "MyEKS"
    owner       = "Hello-World"
  }
}