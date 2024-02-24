variable "num_cache_clusters" {
  type        = number
  default     = 1
  description = "The number of cache clusters (primary and replicas) this replication group will have. If Multi-AZ is enabled, the value of this parameter must be at least 2. Updates will occur before other modifications. Conflicts with num_node_groups."
}

variable "cluster_mode_enabled" {
  type        = bool
  description = "Enable creation of a native redis cluster."
  default     = false
}

variable "node_type" {
  type        = string
  description = "The compute and memory capacity of the nodes in the node group."
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group."
  default     = []
}

variable "subnet_group_name" {
  type        = string
  description = "The name of the subnet group. If it is not specified, the module will create one for you"
  default     = null
}

variable "security_groups_postgres" {
  type        = string
  description = "List of Security Groups."
  default = ""
}


variable "engine_version" {
  default     = "7.x"
  type        = string
  description = "The version number of the cache engine to be used for the cache clusters in this replication group."
}

variable "port" {
  default     = 6379
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}

variable "maintenance_window" {
  default     = ""
  type        = string
  description = "Specifies the weekly time range for when maintenance on the cache cluster is performed."
}

variable "automatic_failover_enabled" {
  default     = true
  type        = bool
  description = "Specifies whether a read-only replica will be automatically promoted to read/write primary if the existing primary fails. If enabled, number_cache_clusters must be greater than 1. Must be enabled for Redis (cluster mode enabled) replication groups."
}

variable "at_rest_encryption_enabled" {
  default     = true
  type        = bool
  description = "Whether to enable encryption at rest."
}

variable "transit_encryption_enabled" {
  default     = true
  type        = bool
  description = "Whether to enable encryption in transit."
}

variable "apply_immediately" {
  default     = false
  type        = bool
  description = "Specifies whether any modifications are applied immediately, or during the next maintenance window."
}

variable "family" {
  default     = "redis6.x"
  type        = string
  description = "The family of the ElastiCache parameter group."
}

variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}

variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}

variable "auth_token" {
  type        = string
  description = "The password used to access a password protected server. Can be specified only if `transit_encryption_enabled = true`."
  default     = ""
}
variable "auth_token_update_strategy" {
  type = string
  description = "strategy"
  default = ""
}


variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}

variable "parameter_group_name" {
  type = string
  default = ""
}

variable "replicas_per_node_group" {
  type        = number
  default     = 0
  description = "Specify the number of replica nodes in each node group. Valid values are 0 to 5. Changing this number will trigger an online resizing operation before other settings modifications."

  validation {
    condition     = var.replicas_per_node_group <= 5
    error_message = "The replicas_per_node_group value must be between 0 and 5."
  }
}

variable "num_node_groups" {
  type        = number
  default     = 0
  description = "Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications."
}


variable "final_snapshot_identifier" {
  type        = string
  description = "The name of your final node group (shard) snapshot. ElastiCache creates the snapshot from the primary node in the cluster. If omitted, no final snapshot will be made."
  default     = null
}

variable "replication_group_id" {
  description = "The ID of the global replication group to which this replication group should belong."
  type        = string
  default     = null
}


variable "allowed_security_groups" {
  type        = list(string)
  description = "List of existing security groups that will be allowed ingress via the elaticache security group rules"
  default     = []
}


variable "vpc_id" {
  description = " vpc id"
  type = string
}


variable "cidr_ingress_1" {
  type = string
}

variable "cidr_ingress_2" {
  type = string
}