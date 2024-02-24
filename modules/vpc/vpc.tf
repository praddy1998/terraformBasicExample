#------------------------------------------------------------------------------------------------------#
#Code to create AWS VPC.                                                                               #
#------------------------------------------------------------------------------------------------------#

# Create AWS VPC


resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  lifecycle {
    create_before_destroy = true
  }
  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
    managed_by  = "terraform"
    region      = var.region
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = var.ingress_from_port
    to_port   = var.ingress_to_port
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}