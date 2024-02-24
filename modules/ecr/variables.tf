variable "name" {
  type = list
  description = "(Required) Name of the repository.{name}."
}

variable "project_family" {
  type = string
  description = "(Required) Project name of the repository.{name}."
}

variable "environment" {
  type = string
  description = "(Optional) Repository environment.{environment}/{name}. Default is prod."
  default = ""
}

variable "image_tag_mutability" {
  type = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default = "MUTABLE"
}

variable "scan_on_push" {
  type = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default = false
}

variable "additional_tags" {
  type = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default = {}
}


variable "expiration_after_days" {
  type = number
  description = "(Optional) Delete images older than X days."
  default = 7
}