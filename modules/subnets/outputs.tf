#------------------------------------------------------------------------------------------------------#
#Output from the Module to get in statefile so that we can reference it later                          #
#------------------------------------------------------------------------------------------------------#

output "public_subnets" {
  value = [aws_subnet.public.*.id]
}

output "private_subnets" {
  value = [aws_subnet.private.*.id]
}

output "public_azs" {
  value = aws_subnet.public.*.availability_zone
}

output "private_azs" {
  value = aws_subnet.private.*.availability_zone
}

output "public_route_table_id" {
  value = aws_route_table.public.*.id
}

output "private_route_table_ids" {
  value = [aws_route_table.private.*.id]
}
/*
output "nat_eips" {
  value = [aws_eip.nat.*.public_ip]
}
*/
output "rds_subnet_group" {
  value = aws_db_subnet_group.rds_subnet_group.name
}

output "redis_subnet_group" {
  value = aws_elasticache_subnet_group.redis_subnet_group
}

output "rds_public_subnet_group" {
  value = aws_db_subnet_group.rds_public_subnet_group.name
}