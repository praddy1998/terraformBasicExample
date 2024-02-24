#------------------------------------------------------------------------------------------------------#
#All variables along with default value should go here, can be overwrite from the environments.        #
#Each module will have its own variables.                                                              #
#------------------------------------------------------------------------------------------------------#


variable "env" {
  description = "Environment name"
}


variable "public_subnets" {
  description = "List of public subnets CIDR blocks"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "List of private subnets CIDR blocks"
  type        = list(string)
  default     = []
}

variable "azs" {
  description = "Comma separated lists of AZs in which to distribute subnets"
}

variable "vpc_id" {
  description = "vpc id in which the subnets will create"

}

/*variable "nat_gateways_count" {
  description = "NAT Gateway to be created."
  default     = 1
}*/

variable "security_groups_postgres" {
  type        = list(string)
  description = "List of Security Groups."
  default = [  ]
}

variable "cluster_name" {
  description = "set kubernetes.io/cluster/my-cluster for alb"
}
