module "xc_aws_vpc" {
  source  = "f5devcentral/aws-vpc-site-networking/xc"
  version = "0.0.5"

  name                                     = ("" != var.prefix) ? format("%s-%s", var.prefix, var.name) : var.name
  existing_vpc_id                          = ("" != var.existing_vpc_id) ? var.existing_vpc_id : null
  az_names                                 = var.az_names
  create_outside_route_table               = var.create_outside_route_table
  create_internet_gateway                  = var.create_internet_gateway
  create_outside_security_group            = var.create_outside_security_group
  create_inside_security_group             = var.create_inside_security_group
  create_udp_security_group_rules          = var.create_udp_security_group_rules
  tags                                     = var.tags
  local_subnets                            = var.local_subnets
  inside_subnets                           = var.inside_subnets
  outside_subnets                          = var.outside_subnets
  workload_subnets                         = var.workload_subnets
  vpc_cidr                                 = ("" != var.vpc_cidr) ? var.vpc_cidr : null
  vpc_instance_tenancy                     = var.vpc_instance_tenancy
  vpc_enable_dns_hostnames                 = var.vpc_enable_dns_hostnames
  vpc_enable_dns_support                   = var.vpc_enable_dns_support
  vpc_enable_network_address_usage_metrics = var.vpc_enable_network_address_usage_metrics
}