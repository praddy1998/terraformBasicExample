resource "aws_security_group" "add_sg" {
  name        = var.add_sg
  description = "Security group for eks"
  vpc_id = var.vpc_id  
  tags = {
    Name = "test-add_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}




resource "aws_security_group_rule" "self_ingress_efs" {
  type                     = "ingress"
  security_group_id        = aws_security_group.add_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  self                     = true
}

  resource "aws_security_group_rule" "egress_efs" {
  type                     = "egress"
  security_group_id        = aws_security_group.add_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = var.cidr_ingress_1
  #source_security_group_id = var.security_groups_postgres
}
