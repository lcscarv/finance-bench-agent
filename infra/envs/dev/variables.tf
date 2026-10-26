variable "budget_alert_email" {
  description = "Recipient of budget alerts (set in terraform.tfvars, kept out of git)"
  type        = string
}

variable "monthly_budget_usd" {
  description = "Monthly cost ceiling for the project in this account"
  type        = string
  default     = "25"
}
