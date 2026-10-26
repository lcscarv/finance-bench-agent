output "cluster_arn" {
  description = "Resource ARN for RDS Data API calls"
  value       = aws_rds_cluster.this.arn
}

output "cluster_identifier" {
  value = aws_rds_cluster.this.cluster_identifier
}

output "secret_arn" {
  description = "Secrets Manager secret holding the master credentials"
  value       = aws_rds_cluster.this.master_user_secret[0].secret_arn
}

output "database_name" {
  value = aws_rds_cluster.this.database_name
}
