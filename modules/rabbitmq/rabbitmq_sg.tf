resource "aws_security_group" "rabbitmq" {
  name        = "test-rabbitmq-SecurityGroup"
  description = "Security group for rabbitmq instance"

  vpc_id = var.vpc_id  
 


  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [var.cidr_ingress_2]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_ingress_1]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_ingress_2]  
  }

  tags = {
    Name = "test-rabbitmq"
    
  }
}