variable "name" {
  description = "Name prefix for network resources"
  type        = string
}

variable "cidr_block" {
  description = "VPC CIDR; each subnet gets a /24 when this is a /16"
  type        = string
}

variable "az_count" {
  description = "Number of AZs (Aurora subnet groups need at least 2)"
  type        = number
  default     = 2

  validation {
    condition     = var.az_count >= 2
    error_message = "Aurora requires subnets in at least 2 AZs."
  }
}
