output "vpc_id" {
  value = module.network.vpc_id
}

output "db_cluster_arn" {
  value = module.vector_store.cluster_arn
}

output "db_secret_arn" {
  value = module.vector_store.secret_arn
}

output "db_name" {
  value = module.vector_store.database_name
}

output "embedding_profile_arn" {
  value = module.bedrock_profiles.embedding_profile_arn
}
