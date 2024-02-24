resource "aws_security_group" "redis" {
  name        = "test-redis-securitygroup"
  description = "Security group for redis instance"

  vpc_id = var.vpc_id  
  tags = {
    Name = "test-redis"
    
  }
}

resource "aws_security_group_rule" "ingress"{
  type                     = "ingress"
  security_group_id        = aws_security_group.redis.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  //source_security_group_id = var.security_groups_postgres
  cidr_blocks = [var.cidr_ingress_1]
}
  resource "aws_security_group_rule" "egress" {
  type                     = "egress"
  security_group_id        = aws_security_group.redis.id
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  //source_security_group_id = var.security_groups_postgres
  cidr_blocks = [var.cidr_ingress_2]
}