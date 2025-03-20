variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
}

variable "ebs_csi_driver_role_arn" {
  description = "ARN of the IAM role for the EBS CSI driver"
  type        = string
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