variable "name" {
  description = "Name prefix for the inference profiles"
  type        = string
}

variable "embedding_model_id" {
  description = "On-demand foundation model used for embeddings"
  type        = string
  default     = "amazon.titan-embed-text-v2:0"
}

variable "generation_profile_id" {
  description = "System-defined cross-region inference profile for answer generation"
  type        = string
  default     = "us.anthropic.claude-haiku-5-5"
}
