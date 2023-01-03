# Outputs
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
  description = "Required for deploying an EKS cluster(separate terraform project) to VPC if create_infra is true and create_juice_shop is false"
  value = [values(aws_subnet.external)[0].id, values(aws_subnet.external)[1].id]
}
/*
output network_cidr_blocks {
  value = module.subnet_addrs
}
*/
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
output "extSubnetAz1" {
  description = "ID of External subnet AZ1"
  value       = values(aws_subnet.external)[0].id
}
output "extSubnetAz2" {
  description = "ID of External subnet AZ2"
  value       = values(aws_subnet.external)[1].id
}
output "intSubnetAz1" {
  description = "ID of Internal subnet AZ1"
  value       = values(aws_subnet.internal)[0].id
}
output "intSubnetAz2" {
  description = "ID of Internal subnet AZ2"
  value       = values(aws_subnet.internal)[1].id
}
output "mgmtSubnetAz1" {
  description = "ID of Management subnet AZ1"
  value       = values(aws_subnet.management)[0].id
}
output "mgmtSubnetAz2" {
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



