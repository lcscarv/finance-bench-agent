output "embedding_profile_arn" {
  description = "Pass as modelId to InvokeModel for embeddings"
  value       = aws_bedrock_inference_profile.embedding.arn
}

# TODO(lucas): output "generation_profile_arn"
