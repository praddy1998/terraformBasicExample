variable "name" {}
variable "env" {}
variable "subnet_ids" {}
variable "eks_cidr" {}
variable "eks-master-role" {
  type    = string
  default = ""
}

variable "vpc_id" {
}

variable "security_groups_postgres" {
}

variable "cidr_ingress_1" {
}

variable "eks_add_sg_name" {
}

variable "addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    
  ]
}