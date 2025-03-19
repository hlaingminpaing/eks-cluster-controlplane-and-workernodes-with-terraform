# IAM Role for EKS Cluster
resource "aws_iam_role" "eks_cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cluster-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

# EKS Cluster
resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = "1.32"

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = merge(
    var.tags,
    {
      Name = var.cluster_name
    }
  )
}

# OIDC Provider for EKS Cluster
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-oidc-provider"
    }
  )
}

# IAM Role for Amazon EBS CSI Driver
resource "aws_iam_role" "ebs_csi_driver" {
  name = "${var.cluster_name}-ebs-csi-driver-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRoleWithWebIdentity"
        Effect    = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.eks.arn
        }
        Condition = {
          StringEquals = {
            "${aws_iam_openid_connect_provider.eks.url}:sub" = "system:serviceaccount:kube-system:ebs-csi-controller-sa"
          }
        }
      }
    ]
  })

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-ebs-csi-driver-role"
    }
  )
}

resource "aws_iam_role_policy_attachment" "ebs_csi_driver_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
  role       = aws_iam_role.ebs_csi_driver.name
}

# Data sources to fetch the most recent compatible add-on versions
data "aws_eks_addon_version" "coredns" {
  addon_name         = "coredns"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "ebs_csi" {
  addon_name         = "aws-ebs-csi-driver"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "kube_proxy" {
  addon_name         = "kube-proxy"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "vpc_cni" {
  addon_name         = "vpc-cni"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "metrics_server" {
  addon_name         = "metrics-server"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

data "aws_eks_addon_version" "cloudwatch_observability" {
  addon_name         = "amazon-cloudwatch-observability"
  kubernetes_version = aws_eks_cluster.main.version
  most_recent        = true
}

# EKS Add-ons
resource "aws_eks_addon" "coredns" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "coredns"
  addon_version = data.aws_eks_addon_version.coredns.version

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-coredns"
    }
  )
}

resource "aws_eks_addon" "ebs_csi" {
  cluster_name             = aws_eks_cluster.main.name
  addon_name               = "aws-ebs-csi-driver"
  addon_version            = data.aws_eks_addon_version.ebs_csi.version
  service_account_role_arn = aws_iam_role.ebs_csi_driver.arn

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-ebs-csi"
    }
  )
}

resource "aws_eks_addon" "kube_proxy" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "kube-proxy"
  addon_version = data.aws_eks_addon_version.kube_proxy.version

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-kube-proxy"
    }
  )
}

resource "aws_eks_addon" "vpc_cni" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "vpc-cni"
  addon_version = data.aws_eks_addon_version.vpc_cni.version

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-vpc-cni"
    }
  )
}

resource "aws_eks_addon" "metrics_server" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "metrics-server"
  addon_version = data.aws_eks_addon_version.metrics_server.version

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-metrics-server"
    }
  )
}

resource "aws_eks_addon" "cloudwatch_observability" {
  cluster_name  = aws_eks_cluster.main.name
  addon_name    = "amazon-cloudwatch-observability"
  addon_version = data.aws_eks_addon_version.cloudwatch_observability.version

  tags = merge(
    var.tags,
    {
      Name = "${var.cluster_name}-cloudwatch-observability"
    }
  )
}