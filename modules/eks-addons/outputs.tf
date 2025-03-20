output "addon_coredns_version" {
  description = "Version of the CoreDNS add-on"
  value       = aws_eks_addon.coredns.addon_version
}

output "addon_ebs_csi_version" {
  description = "Version of the EBS CSI add-on"
  value       = aws_eks_addon.ebs_csi.addon_version
}

output "addon_kube_proxy_version" {
  description = "Version of the kube-proxy add-on"
  value       = aws_eks_addon.kube_proxy.addon_version
}

output "addon_vpc_cni_version" {
  description = "Version of the VPC CNI add-on"
  value       = aws_eks_addon.vpc_cni.addon_version
}

output "addon_metrics_server_version" {
  description = "Version of the Metrics Server add-on"
  value       = aws_eks_addon.metrics_server.addon_version
}

output "addon_cloudwatch_observability_version" {
  description = "Version of the CloudWatch Observability add-on"
  value       = aws_eks_addon.cloudwatch_observability.addon_version
}