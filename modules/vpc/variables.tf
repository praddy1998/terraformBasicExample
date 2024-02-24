#------------------------------------------------------------------------------------------------------#
#All variables along with default value should go here, can be overwrite from the environments.        #
#Each module will have its own variables.                                                              #
#------------------------------------------------------------------------------------------------------#


variable "env" {
  description = "Environment name"
}

variable "cidr" {
  description = "The CIDR block for the VPC."
}

variable "enable_dns_hostnames" {
  description = "True or False to enable/disable the DNS hostnames in VPC."
  default     = true
}

variable "enable_dns_support" {
  description = "True or False to enable/disable the DNS support in VPC."
  default     = true
}

variable "region" {
  description = "AWS region where the infrastructure will come up."
  default     = ""
}
variable "ingress_from_port" {
  
}
variable "ingress_to_port" {
  
}