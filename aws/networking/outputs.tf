output "vpc_id" {
  value       = module.xc_aws_vpc.vpc_id
  description = "The ID of the VPC."
}

output "vpc_name" {
  value       = module.xc_aws_vpc.vpc_name
  description = "The name of the VPC."
}

output "vpc_cidr" {
  value       = module.xc_aws_vpc.vpc_cidr
  description = "The CIDR block of the VPC."
}

output "outside_subnet_ids" {
  value       = module.xc_aws_vpc.outside_subnet_ids
  description = "The IDs of the outside subnets."
}

output "inside_subnet_ids" {
  value       = module.xc_aws_vpc.inside_subnet_ids
  description = "The IDs of the inside subnets."
}

output "workload_subnet_ids" {
  value       = module.xc_aws_vpc.workload_subnet_ids
  description = "The IDs of the workload subnets."
}

output "local_subnet_ids" {
  value       = module.xc_aws_vpc.local_subnet_ids
  description = "The IDs of the local subnets."
}

output "outside_route_table_id" {
  value       = module.xc_aws_vpc.outside_route_table_id
  description = "The ID of the outside route table."
}

output "internet_gateway_id" {
  value       = module.xc_aws_vpc.internet_gateway_id
  description = "The ID of the internet gateway."
}

output "outside_security_group_id" {
  value       = module.xc_aws_vpc.outside_security_group_id
  description = "The ID of the outside security group."
}
  
output "inside_security_group_id" {
  value       = module.xc_aws_vpc.inside_security_group_id
  description = "The ID of the inside security group."
}

output "default_security_group_id" {
  value       = module.xc_aws_vpc.default_security_group_id
  description = "The ID of the default security group."
}

output "az_names" {
  value       = module.xc_aws_vpc.az_names
  description = "Availability zones."
}