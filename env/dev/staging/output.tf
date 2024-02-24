output "public_subnets" {
    value = module.subnets.public_subnets
}


output "endpoint" {
  value = module.eks.endpoint
}


output "cidr_block" {
  value = module.vpc.cidr_block
}

/*

output "eks_cluster_ca_cert_data" {
  value = module.eks.cluster_certificate_authority_data
}

output "secret" {
  value= module.secretsmanager.sensitive_example_hash
}

*/
