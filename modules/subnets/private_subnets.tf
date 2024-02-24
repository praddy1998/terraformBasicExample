## Flexible tag management

resource "null_resource" "private_subnet_tags" {
  count = length(var.private_subnets)
  triggers = merge(
    {
      Name        = "${element(local.availability_zones, count.index)}-${var.env}-private-subnet"
      Environment = var.env
      managed_by  = "terraform"
    },
    var.private_subnet_tags
  )
}

variable private_subnet_tags {
  type    = map(string)
  default = {
    
  }
}

## Private subnet/s
resource "aws_subnet" "private" {
  vpc_id            = var.vpc_id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = element(local.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = null_resource.private_subnet_tags[count.index].triggers
}
resource "aws_route_table" "private" {
  vpc_id = var.vpc_id
  count  = length(var.private_subnets)

  tags = {
    Name        = "${element(local.availability_zones, count.index)}-${var.env}-private-route-table"
    Environment = var.env
    managed_by  = "terraform"
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
  count          = length(var.private_subnets)
}
/*
## NAT gateway
resource "aws_eip" "nat" {
 count = var.nat_gateways_count * signum(length(var.private_subnets))
  vpc   = true
}


resource "aws_route" "nat_gateway" {
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  count                  = length(var.private_subnets) * signum(var.nat_gateways_count)
  depends_on             = [aws_route_table.private]
}


resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  count         = var.nat_gateways_count * signum(length(var.private_subnets))
   tags = {
    Name        = "${var.env}-nat-gateway"
    Environment = var.env
    managed_by  = "terraform"
  }
}
*/

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "rds-subnet-group-${var.env}"
  description= "rds DB subnet group" 
  subnet_ids = aws_subnet.private[*].id
}

resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group-${var.env}"
  description= "redis subnet group" 
  subnet_ids = aws_subnet.private[*].id
}