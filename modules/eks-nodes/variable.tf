variable "name" {}
variable "env" {}
variable "subnet_ids" {}
variable "cluster_name" {}
variable "instance_type" {}
variable "desired_size" {}
variable "max_size" {}
variable "min_size" {}
variable "ami_type" {
}
variable "ssh_key" {}
variable "eks-node-group-role" {
  type = string
  default = ""
}
variable "remote_access_sg_id" {
  
}
variable "capacity_type" {
  
}