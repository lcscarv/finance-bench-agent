variable "region" {
  description = "AWS region for the state bucket"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Project name, used in resource names and tags"
  type        = string
  default     = "financebench"
}

variable "noncurrent_version_days" {
  description = "Days to keep old state versions before expiring them"
  type        = number
  default     = 90
}
