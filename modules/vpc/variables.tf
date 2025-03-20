variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "uat-vpc"
}

variable "region" {
  description = "AWS region for the deployment"
  type        = string
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

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
  default     = "uat-eks-cluster"  # Optional default value
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