
resource "aws_eks_cluster" "example" {
  name     = var.name
  role_arn = aws_iam_role.example.arn

  vpc_config {
    subnet_ids = var.subnet_ids
     security_group_ids = [aws_security_group.eks_add_sg.id]
  }
  kubernetes_network_config  {
    service_ipv4_cidr = var.eks_cidr
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.example-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.example-AmazonEKSVPCResourceController,
  ]

  tags = {
    Name = var.name
    Environment = var.env
  }
}


resource "aws_iam_role" "example" {
  name = var.eks-master-role

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

data "tls_certificate" "example" {
  url = aws_eks_cluster.example.identity[0].oidc[0].issuer
}


resource "aws_iam_openid_connect_provider" "example" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.example.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.example.identity[0].oidc[0].issuer
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.example.name
}

resource "aws_iam_role_policy_attachment" "example-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.example.name
}



# Optionally, enable Security Groups for Pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "example-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.example.name
}
/*
resource "aws_eks_addon" "aws_eks_addon" {
  cluster_name                = aws_eks_cluster.example.name
  addon_name                  = "coredns"
  //addon_version               = "v1.10.1-eksbuild.1" #e.g., previous version v1.9.3-eksbuild.3 and the new version is v1.10.1-eksbuild.1
  resolve_conflicts_on_update = "PRESERVE"

}
*/

output "eks_cluster_ca_cert_data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
  
}

resource "aws_eks_addon" "addons" {
  for_each          = { for addon in var.addons : addon.name => addon }
  cluster_name      = aws_eks_cluster.example.id
  addon_name        = each.value.name
  addon_version     = each.value.version
  resolve_conflicts = "PRESERVE"
}
