# ---------------------------------------------------------------------------- #
# These data-sources gather the necessary VPC information if create VPC is not specified
# ---------------------------------------------------------------------------- #
data "aws_vpc" "default" {
  count   = var.create_infra ? 0 : 1
  default = true
}

data "aws_subnets" "subnets" {
  count  = var.create_infra ? 0 : 1
  filter {
    name = "vpc-id"
    values = [data.aws_vpc.default[0].id]
  }
}