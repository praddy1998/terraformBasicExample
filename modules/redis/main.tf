resource "aws_elasticache_replication_group" "redis" {

  automatic_failover_enabled  = var.automatic_failover_enabled
  replication_group_id        = var.replication_group_id
  description                 = var.description
  node_type                   = var.node_type
  num_cache_clusters          = var.num_cache_clusters
  parameter_group_name        = var.parameter_group_name 
  port                        = var.port
  apply_immediately           = var.apply_immediately
  engine_version              = var.engine_version
  subnet_group_name           = var.subnet_group_name
  security_group_ids          = [aws_security_group.redis.id] 
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  transit_encryption_enabled  = var.transit_encryption_enabled
  auth_token                  = var.auth_token
  auth_token_update_strategy  = var.auth_token_update_strategy
  

  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis-log-group.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }

}

resource "aws_cloudwatch_log_group" "redis-log-group" {
  name = "redis-log-group"

}