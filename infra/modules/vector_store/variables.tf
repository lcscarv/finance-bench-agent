variable "name" {
  description = "Cluster identifier"
  type        = string
}

variable "engine_version" {
  description = "Exact Aurora PostgreSQL version (must ship pgvector and support min_capacity = 0)"
  type        = string
}

variable "database_name" {
  description = "Initial database created in the cluster"
  type        = string
}

variable "master_username" {
  description = "Master user; its password is managed by RDS in Secrets Manager"
  type        = string
  default     = "fbadmin"
}

variable "db_subnet_group_name" {
  type = string
}

variable "db_security_group_id" {
  type = string
}

variable "min_capacity" {
  description = "Minimum ACUs; 0 enables auto-pause"
  type        = number
  default     = 0
}

variable "max_capacity" {
  description = "Maximum ACUs; acts as the cost ceiling"
  type        = number
  default     = 2
}

variable "seconds_until_auto_pause" {
  description = "Idle seconds before the cluster pauses (only used when min_capacity = 0)"
  type        = number
  default     = 600

  validation {
    condition     = var.seconds_until_auto_pause >= 300 && var.seconds_until_auto_pause <= 86400
    error_message = "Aurora accepts 300 to 86400 seconds."
  }
}

variable "backup_retention_days" {
  type    = number
  default = 1
}

variable "deletion_protection" {
  description = "When true, also takes a final snapshot on destroy"
  type        = bool
  default     = true
}
