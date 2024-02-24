resource "aws_instance" "bastion" {
  ami             = var.ami
  instance_type   = var.instance_type
  subnet_id       = var.subnet_ids
  vpc_security_group_ids = [aws_security_group.ec2.id]
  key_name        = var.key_name

  tags = {
    Name = "bastion"
  }
}

resource "aws_security_group" "ec2" {
  name        = var.aws_ec2_sg_name
  description = "Security group for ec2 instance"

  vpc_id = var.vpc_id
  tags = {
    Name = "test-postgres-ec2"
  }

}
/*
resource "aws_security_group_rule" "ingress_pub" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 22
  to_port           = 22
  protocol          = -1
  cidr_blocks       = var.cidr_ingress_2
  #source_security_group_id = var.security_groups_eks
}
*/

resource "aws_security_group_rule" "self_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.ec2.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = var.cidr_ingress_1
  #source_security_group_id = var.security_groups_redis
}
