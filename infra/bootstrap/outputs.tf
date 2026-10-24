output "state_bucket" {
  description = "Name of the remote state bucket"
  value       = aws_s3_bucket.state.bucket
}

output "backend_config" {
  description = "Backend block to paste into each stack (change the key per stack)"
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket       = "${aws_s3_bucket.state.bucket}"
        key          = "envs/dev/terraform.tfstate"
        region       = "${var.region}"
        encrypt      = true
        use_lockfile = true
      }
    }
  EOT
}
