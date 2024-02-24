## Flexible tag management

resource "null_resource" "subnet_tags" {
  count = length(var.public_subnets)
  triggers = merge(
    {
      Name        = "${element(local.availability_zones, count.index)}-${var.env}-public-subnet"
      Environment = var.env
      managed_by  = "terraform"
      "kubernetes.io/cluster/${var.cluster_name}"= "shared"
      "kubernetes.io/role/elb"=  1
    },
    var.public_subnet_tags
  )
}

variable public_subnet_tags {
  type    = map(string)
  default = {
   
  }
}

## Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id
  count  = signum(length(var.public_subnets))

  tags = {
    Name        = "${var.env}-igw"
    Environment = var.env
    managed_by  = "terraform"
  }
}

## Public subnet/s
resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = element(local.availability_zones, count.index)
  count                   = length(var.public_subnets)
  map_public_ip_on_launch = true
  tags                    = null_resource.subnet_tags[count.index].triggers
}

resource "aws_route_table" "public" {
  vpc_id = var.vpc_id
  count  = signum(length(var.public_subnets))

  tags = {
    Name        = "${element(local.availability_zones, count.index)}-${var.env}-public-route-table"
    Environment = var.env
    managed_by  = "terraform"
  }
}

resource "aws_route" "default" {
  count                  = signum(length(var.public_subnets))
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  
  gateway_id             = aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public[0].id
}


resource "aws_db_subnet_group" "rds_public_subnet_group" {
  name       = "rds-public-subnet-group-${var.env}"
  description= "rds DB subnet group" 
  subnet_ids = aws_subnet.public[*].id
}