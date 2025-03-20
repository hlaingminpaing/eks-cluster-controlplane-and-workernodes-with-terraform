output "alb_controller_role_arn" {
  description = "ARN of the IAM role for the AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

output "deployment_name" {
  description = "Name of the Kubernetes Deployment for the AWS Load Balancer Controller"
  value       = kubernetes_manifest.deployment.manifest.metadata.name
}
