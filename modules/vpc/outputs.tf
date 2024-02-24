#------------------------------------------------------------------------------------------------------#
#Output from the Module to get in statefile so that we can reference it later                          #
#------------------------------------------------------------------------------------------------------#

output "vpc_id" {
  value = aws_vpc.vpc.id
}


output "cidr_block" {
  value = aws_vpc.vpc.cidr_block
}

