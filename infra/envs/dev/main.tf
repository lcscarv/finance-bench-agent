locals {
  project     = "financebench"
  environment = "dev"
  region      = "us-east-1"
  name        = "${local.project}-${local.environment}"
}

module "network" {
  source = "../../modules/network"

  name       = local.name
  cidr_block = "10.20.0.0/16"
}

module "vector_store" {
  source = "../../modules/vector_store"

  name           = local.name
  engine_version = "16.15"
  database_name  = local.project

  db_subnet_group_name = module.network.db_subnet_group_name
  db_security_group_id = module.network.db_security_group_id

  min_capacity             = 0
  max_capacity             = 2
  seconds_until_auto_pause = 600

  # Dev is disposable: data is rebuilt from the PDFs by re-running ingestion
  deletion_protection = false
}

module "bedrock_profiles" {
  source = "../../modules/bedrock_profiles"

  name = local.name
}

# Only counts resources tagged project=financebench, once that tag is
# activated as a cost allocation tag in Billing
resource "aws_budgets_budget" "monthly" {
  name         = "${local.name}-monthly"
  budget_type  = "COST"
  limit_amount = var.monthly_budget_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  cost_filter {
    name   = "TagKeyValue"
    values = [format("user:project$%s", local.project)]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 40
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.budget_alert_email]
  }

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 100
    threshold_type             = "PERCENTAGE"
    notification_type          = "FORECASTED"
    subscriber_email_addresses = [var.budget_alert_email]
  }
}
