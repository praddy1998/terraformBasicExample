resource "aws_security_group" "efs_eks_node_sg" {
  name        = var.efs_eks_node_sg
  description = "Security group for eks"
  vpc_id = var.vpc_id  
  tags = {
    Name = "test-efs_eks_node_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}




resource "aws_security_group_rule" "self_ingress" {
  type                     = "ingress"
  security_group_id        = aws_security_group.efs_eks_node_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  self                     = true
}

  resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.efs_eks_node_sg.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = var.cidr_ingress_1
  #source_security_group_id = var.security_groups_postgres
}
