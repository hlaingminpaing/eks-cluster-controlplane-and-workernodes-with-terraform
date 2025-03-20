output "node_group_name" {
  description = "Name of the EKS node group"
  value       = aws_eks_node_group.main.node_group_name
}

output "node_group_arn" {
  description = "ARN of the EKS node group"
  value       = aws_eks_node_group.main.arn
}

output "node_group_status" {
  description = "Status of the EKS node group"
  value       = aws_eks_node_group.main.status
}

output "node_group_role_arn" {
  description = "ARN of the IAM role associated with the node group"
  value       = aws_iam_role.node_group.arn
}

output "node_group_scaling_config" {
  description = "Scaling configuration of the node group"
  value       = {
    desired_size = aws_eks_node_group.main.scaling_config[0].desired_size
    max_size     = aws_eks_node_group.main.scaling_config[0].max_size
    min_size     = aws_eks_node_group.main.scaling_config[0].min_size
  }
}

output "node_group_instance_types" {
  description = "Instance types used by the node group"
  value       = aws_eks_node_group.main.instance_types
}