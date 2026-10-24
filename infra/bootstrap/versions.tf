terraform {
  # use_lockfile (S3 native locking) needs 1.10+
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  # Local state on purpose: this stack creates the remote state bucket itself.
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      project    = var.project
      component  = "bootstrap"
      managed_by = "terraform"
    }
  }
}
