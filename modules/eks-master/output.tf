output "endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.example.certificate_authority[0].data
}

output "k8s-cluster-name" {
  value = aws_eks_cluster.example.name
}

output "eks_add_sg" {
  value = aws_security_group.eks_add_sg
}
output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.example.arn
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = try(aws_eks_cluster.example.certificate_authority[0].data, null)
}