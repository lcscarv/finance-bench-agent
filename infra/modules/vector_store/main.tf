resource "aws_rds_cluster" "this" {
  cluster_identifier = var.name
  engine             = "aurora-postgresql"
  engine_mode        = "provisioned" # Serverless v2 runs on the provisioned engine mode
  engine_version     = var.engine_version

  database_name   = var.database_name
  master_username = var.master_username
  # AWS generates and stores the password in Secrets Manager; it never touches state
  manage_master_user_password = true

  db_subnet_group_name   = var.db_subnet_group_name
  vpc_security_group_ids = [var.db_security_group_id]

  # RDS Data API: HTTPS + IAM access, no network path into the VPC needed
  enable_http_endpoint = true

  serverlessv2_scaling_configuration {
    min_capacity             = var.min_capacity
    max_capacity             = var.max_capacity
    seconds_until_auto_pause = var.min_capacity == 0 ? var.seconds_until_auto_pause : null
  }

  storage_encrypted       = true
  backup_retention_period = var.backup_retention_days
  copy_tags_to_snapshot   = true

  deletion_protection       = var.deletion_protection
  skip_final_snapshot       = !var.deletion_protection
  final_snapshot_identifier = var.deletion_protection ? "${var.name}-final" : null

  apply_immediately = true
}

resource "aws_rds_cluster_instance" "this" {
  identifier         = "${var.name}-1"
  cluster_identifier = aws_rds_cluster.this.id
  instance_class     = "db.serverless"
  engine             = aws_rds_cluster.this.engine
  engine_version     = aws_rds_cluster.this.engine_version

  publicly_accessible          = false
  performance_insights_enabled = false
  # The version is pinned in code; upgrades happen by changing it here
  auto_minor_version_upgrade = false

  apply_immediately = true
}
