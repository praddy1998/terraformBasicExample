variable "db_name" {
  description = "The name of the MySQL database"
  type        = string
}

variable "username" {
  description = "The username for the MySQL database"
  type        = string
}

variable "password" {
  description = "The password for the MySQL database"
  type        = string
}

variable "instance_class" {
  description = "The instance type for the RDS MySQL instance"
  type        = string
}

variable "allocated_storage" {
  description = "The amount of storage to allocate to the RDS MySQL instance (in GB)"
  type        = number
}

variable "engine_version" {
  description = "The version of the MySQL engine"
  type        = string
}

variable "vpc_id" {
  description = " vpc id"
  type = string
}

variable "rds_subnet_group" {
  description = "rds_subnet_group"
  type = string
}

variable "cidr_ingress_1" {
  type = list(string)
  default = [ ]
}

variable "cidr_ingress_2" {
  type = list(string)
  default = [ ]
}

variable "security_groups_redis" {
  type        = string
  description = "List of Security Groups."
  default = ""
}

variable "aws_rds_sg_name" {
  default = ""
}

variable "publicly_accessible" {
  default = false
  type = bool
}

variable "security_groups_eks" {
  
}

variable "skip_final_snapshot" {
  
}