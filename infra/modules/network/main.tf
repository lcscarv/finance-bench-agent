data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = { Name = var.name }
}

# No internet gateway and no NAT: these subnets only have the local route
resource "aws_subnet" "private" {
  count = var.az_count

  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone = local.azs[count.index]

  tags = { Name = "${var.name}-private-${local.azs[count.index]}" }
}

# Adopting the default SG with no rules removes its allow-all-from-self default
resource "aws_default_security_group" "this" {
  vpc_id = aws_vpc.this.id

  tags = { Name = "${var.name}-default-locked" }
}

# The Data API does not go through the VPC, so the DB needs no ingress rules
resource "aws_security_group" "db" {
  name        = "${var.name}-db"
  description = "Aurora cluster, no ingress (access via RDS Data API only)"
  vpc_id      = aws_vpc.this.id

  tags = { Name = "${var.name}-db" }
}

resource "aws_db_subnet_group" "this" {
  name       = var.name
  subnet_ids = aws_subnet.private[*].id

  tags = { Name = var.name }
}
