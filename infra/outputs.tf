#Global
output "project_prefix" {
  value = var.project_prefix
}
output "resource_owner" {
  value = var.resource_owner
}
output "build_suffix" {
  value = random_id.build_suffix.hex
}
#Outputs
output "aws_region" {
  value = var.aws_region
}
output "azs" {
  value = var.azs
}
output "vpc_cidr_block" {
  description = "CIDR Block"
  value       = module.vpc.vpc_cidr_block
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}
output "vpc_main_route_table_id" {
  value       = aws_route_table.main.id
}
output "public_subnet_ids" {
  value = [values(aws_subnet.external)[0].id, values(aws_subnet.external)[1].id]
}
output "private_cidr_blocks" {
  value = [values(aws_subnet.internal)[0].cidr_block, values(aws_subnet.internal)[1].cidr_block]
}
output "public_cidr_blocks" {
  value  =  [values(aws_subnet.external)[0].cidr_block, values(aws_subnet.external)[1].cidr_block]
}
output "management_cidr_blocks" {
  value = [values(aws_subnet.management)[0].cidr_block, values(aws_subnet.management)[1].cidr_block]
}
output "private_subnet_ids" {
  value = [values(aws_subnet.internal)[0].id, values(aws_subnet.internal)[1].id]
}
output "public_az1_cidr_block" {
value  =  values(aws_subnet.external)[0].cidr_block  
}
output "private_az1_cidr_block" {
value  =  values(aws_subnet.internal)[0].cidr_block  
}
output "app_cidr" {
  description = "Application server(Juice Shop) CIDR block"
  value       = values(module.subnet_addrs)[0].network_cidr_blocks.app-cidr
}
output "eks_cidr" {
  description = "Application server(EKS) CIDR block"
  value       = values(module.subnet_addrs)[1].network_cidr_blocks.app-cidr
}

output "ext_subnet_az1" {
  description = "ID of External subnet AZ1"
  value       = values(aws_subnet.external)[0].id
}
output "ext_subnet_az2" {
  description = "ID of External subnet AZ2"
  value       = values(aws_subnet.external)[1].id
}
output "int_subnet_az1" {
  description = "ID of Internal subnet AZ1"
  value       = values(aws_subnet.internal)[0].id
}
output "int_subnet_az2" {
  description = "ID of Internal subnet AZ2"
  value       = values(aws_subnet.internal)[1].id
}
output "mgmt_subnet_az1" {
  description = "ID of Management subnet AZ1"
  value       = values(aws_subnet.management)[0].id
}
output "mgmt_subnet_az2" {
  description = "ID of Management subnet AZ2"
  value       = values(aws_subnet.management)[1].id
}

output "external_sg_id" {
  value       = aws_security_group.external.id
}
output "management_sg_id" {
  value       = aws_security_group.management.id
}
output "internal_sg_id" {
  value       = aws_security_group.internal.id
}

output "nap" {
  value = var.nap
}
output "nic" {
  value = var.nic
}
output "bigip" {
  value = var.bigip
}
output "bigip-cis" {
  value = var.bigip-cis
}
