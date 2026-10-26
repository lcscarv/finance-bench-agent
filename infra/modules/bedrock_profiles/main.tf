# Application inference profiles: taggable wrappers around a model, so Bedrock
# usage shows up in cost allocation by tag and IAM can be scoped to one ARN.
# Tags come from the provider's default_tags.

data "aws_bedrock_foundation_model" "embedding" {
  model_id = var.embedding_model_id
}

resource "aws_bedrock_inference_profile" "embedding" {
  name        = "${var.name}-embedding"
  description = "Embeddings for ingestion and query (${var.embedding_model_id})"

  model_source {
    copy_from = data.aws_bedrock_foundation_model.embedding.model_arn
  }
}

# TODO(lucas): generation profile
#
# Goal: an aws_bedrock_inference_profile named "${var.name}-generation" for the
# model in var.generation_profile_id, then expose its ARN in outputs.tf.
#
# Unlike the embedding model, Claude on Bedrock is reached through a
# *system-defined* cross-region inference profile (the "us." prefix), not a
# foundation-model ARN. Your profile must copy from that system profile so it
# keeps the cross-region routing.
#
# Hints:
# - Look up the system profile's ARN with a data source instead of building
#   the string by hand (provider docs: "aws_bedrock_inference_profile" data source).
# - Check the result with: terraform plan (copy_from should end in
#   inference-profile/us.anthropic...)
# - Afterwards, answer for yourself: which ARNs will the Lambda role need in
#   bedrock:InvokeModel to call this profile? (Hint: it is more than one.)
