resource "aws_db_instance" "postgres" {
  identifier             = var.db_name
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  username               = var.username
  password               = var.password
  port                   = 5432
  multi_az               = false
  publicly_accessible    = var.publicly_accessible
  skip_final_snapshot    = var.skip_final_snapshot
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = var.rds_subnet_group
  storage_encrypted           = true
  deletion_protection    = true
  apply_immediately = true
  backup_retention_period =7
  
  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "test-postgres-rds"
  }
}
