resource "aws_security_group" "rds" {
  name        = var.aws_rds_sg_name
  description = "Security group for RDS instance"
  vpc_id = var.vpc_id  
  tags = {
    Name = "test-postgres-rds"
  }
  lifecycle {
    create_before_destroy = false
  }
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  #cidr_blocks              = var.cidr_ingress_1
  source_security_group_id = var.security_groups_eks
}

resource "aws_security_group_rule" "ingress_pub" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = var.cidr_ingress_2
  #source_security_group_id = var.security_groups_eks
}


resource "aws_security_group_rule" "self_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  self                     = true
}

  resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = var.cidr_ingress_1
  #source_security_group_id = var.security_groups_redis
}
