#AWS INFRA Outputs
output "vpc_cidr_block" {
  description = "CIDR Block"
  value       = var.create_infra ? module.infra[0].vpc_cidr_block : null
}
output "vpc_id" {
  description = "VPC ID"
  value       = var.create_infra ? module.infra[0].vpc_id : null
}
output "vpc_main_route_table_id" {
  description = "ID of VPC route table"
  value       = var.create_infra ? module.infra[0].vpc_main_route_table_id : null
}
output "public_subnet_ids" {
  description = "Required for deploying an EKS cluster(separate terraform project) to VPC if create_infra is true and create_juice_shop is false"
  value = var.create_infra ? module.infra[0].public_subnet_ids : null
}
/*
output "network_cidr_blocks" {
  value = var.create_infra ? module.infra[0].network_cidr_blocks : null
}
*/
output "extSubnetAz1" {
  description = "ID of External subnet AZ1"
  value       = var.create_infra ? module.infra[0].extSubnetAz1 : null
}
output "extSubnetAz2" {
  description = "ID of External subnet AZ2"
  value       = var.create_infra ? module.infra[0].extSubnetAz2 : null
}
output "intSubnetAz1" {
  description = "ID of Internal subnet AZ1"
  value       = var.create_infra ? module.infra[0].intSubnetAz1 : null
}
output "intSubnetAz2" {
  description = "ID of Internal subnet AZ2"
  value       = var.create_infra ? module.infra[0].intSubnetAz2 : null
}
output "mgmtSubnetAz1" {
  description = "ID of Management subnet AZ1"
  value       = var.create_infra ? module.infra[0].mgmtSubnetAz1 : null
}
output "mgmtSubnetAz2" {
  description = "ID of Management subnet AZ2"
  value       = var.create_infra ? module.infra[0].mgmtSubnetAz2 : null
}

#Juice Shop(EC2) Outputs
output "juice_shop_ip" {
  value = var.create_juice_shop ? module.juice_shop[0].juice_shop_ip : null 
}
output "nat_gateway_id" {
  description = "ID of NGW created by Juice Shop module"
  value = var.create_juice_shop ? module.juice_shop[0].nat_gateway_id : null
}

#BIGIP Outputs

output "f5vm01_mgmt_private_ip" {
  description = "f5vm01 management private IP address"
  value       = var.create_bigip ? module.bigip[0].f5vm01_mgmt_private_ip : null
}
output "f5vm01_mgmt_public_ip" {
  description = "f5vm01 management public IP address"
  value       = var.create_bigip ? module.bigip[0].f5vm01_mgmt_public_ip : null
}
output "f5vm01_mgmt_pip_url" {
  description = "f5vm01 management public URL"
  value       = var.create_bigip ? module.bigip[0].f5vm01_mgmt_pip_url : null
}
output "f5vm01_ext_private_ip" {
  description = "f5vm01 external primary IP address (self IP)"
  value       = var.create_bigip ? module.bigip[0].f5vm01_ext_private_ip : null
}
output "f5vm01_ext_public_ip" {
  description = "f5vm01 external public IP address (self IP)"
  value       = var.create_bigip ? module.bigip[0].f5vm01_ext_public_ip : null
}
output "f5vm01_ext_secondary_ip" {
  description = "f5vm01 external secondary IP address (VIP)"
  value       = var.create_bigip ? module.bigip[0].f5vm01_ext_secondary_ip : null
}
output "f5vm01_int_private_ip" {
  description = "f5vm01 internal primary IP address"
  value       = var.create_bigip ? module.bigip[0].f5vm01_int_private_ip : null
}
output "f5vm01_instance_ids" {
  description = "f5vm01 management device name"
  value       = var.create_bigip ? module.bigip[0].f5vm01_instance_ids : null
}
output "public_vip" {
  description = "Public IP for the BIG-IP listener (VIP)"
  value       = var.create_bigip ? module.bigip[0].public_vip : null
}
output "public_vip_url" {
  description = "public URL for application"
  value       = var.create_bigip ? module.bigip[0].public_vip_url : null
}
output "create_bigip" {
  description = "Set to true to create bigip"
  value = var.create_bigip
}
output "f5_password" {
  description = "BIG-IP Password"
  value = var.create_bigip ? module.bigip[0].f5_password : null
}

#NAP Outputs

#XC LB Outputs 
output "xc_lb_name" {
  value = var.create_xc_lb ? module.xc_lb[0].xc_lb_name : null
}

#XC WAF Outputs
output "xc_waf_name" {
  value = var.create_xc_waf ? module.xc_waf[0].xc_waf_name : null
}

#test
output "private_cidr_blocks" {
  value = var.create_infra ? module.infra[0].private_cidr_blocks : null
}
output "public_cidr_blocks" {
  value = var.create_infra ? module.infra[0].public_cidr_blocks : null
}
#output "management_cidr_blocks" {
#  value = var.create_infra ? module.infra[0].management_cidr_blocks : null
#}

output "private_subnet_ids" {
  value = var.create_infra ? module.infra[0].private_subnet_ids : null
}
output "external_sg_id" {
  value = var.create_infra ? module.infra[0].external_sg_id : null
}
output "internal_sg_id" {
  value = var.create_infra ? module.infra[0].internal_sg_id : null
}
output "management_sg_id" {
  value = var.create_infra ? module.infra[0].management_sg_id : null
}