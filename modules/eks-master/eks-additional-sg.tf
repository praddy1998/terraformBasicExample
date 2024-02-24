resource "aws_security_group" "eks_add_sg" {
  name        = var.eks_add_sg_name
  description = "Security group for eks"
  vpc_id = var.vpc_id  
  tags = {
    Name = "test-eks_add_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_add_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  #cidr_blocks              = var.cidr_ingress_1
  source_security_group_id = var.security_groups_postgres
}


resource "aws_security_group_rule" "self_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.eks_add_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  self                     = true
}

  resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.eks_add_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = var.cidr_ingress_1
  #source_security_group_id = var.security_groups_postgres
}
