#INFRA Outputs
output "vpc_cidr_block" {
  description = "CIDR Block"
  value       = module.onboarding.vpc_cidr_block
}
output "vpc_id" {
  description = "VPC ID"
  value       = module.onboarding.vpc_id
}
output "vpc_main_route_table_id" {
  description = "ID of VPC main route table"
  value      = module.onboarding.vpc_main_route_table_id
}
output "public_subnet_ids" {
  description = "Required for deploying an EKS cluster(separate terraform project) to VPC if create_infra is true and create_juice_shop is false"
  value = module.onboarding.public_subnet_ids
}

#BIG-IP Outputs

output "f5vm01_mgmt_private_ip" {
  description = "f5vm01 management private IP address"
  value       = module.onboarding.f5vm01_mgmt_private_ip
}
output "f5vm01_mgmt_public_ip" {
  description = "f5vm01 management public IP address"
  value       = module.onboarding.f5vm01_mgmt_public_ip
}
output "f5vm01_mgmt_pip_url" {
  description = "f5vm01 management public URL"
  value       = module.onboarding.f5vm01_mgmt_pip_url
}
output "f5vm01_ext_private_ip" {
  description = "f5vm01 external primary IP address (self IP)"
  value       = module.onboarding.f5vm01_ext_private_ip
}
output "f5vm01_ext_public_ip" {
  description = "f5vm01 external public IP address (self IP)"
  value       = module.onboarding.f5vm01_ext_public_ip
}
output "f5vm01_ext_secondary_ip" {
  description = "f5vm01 external secondary IP address (VIP)"
  value       = module.onboarding.f5vm01_ext_secondary_ip
}
output "f5vm01_int_private_ip" {
  description = "f5vm01 internal primary IP address"
  value       = module.onboarding.f5vm01_int_private_ip
}
output "f5vm01_instance_ids" {
  description = "f5vm01 management device name"
  value       = module.onboarding.f5vm01_instance_ids
}
output "public_vip" {
  description = "Public IP for the BIG-IP listener (VIP)"
  value       = module.onboarding.public_vip
}
output "public_vip_url" {
  description = "public URL for application"
  value       = module.onboarding.public_vip_url
}
output "f5_password" {
  description = "BIG-IP Password"
  value = module.onboarding.f5_password
}

#EC2 Outputs
output "juice_shop_ip" {
  value = module.onboarding.juice_shop_ip
}

#XC LB Outputs
output "xc_lb_name" {
  value = module.onboarding.xc_lb_name
}

#XC WAF Outputs
output "xc_waf_name" {
  value = module.onboarding.xc_waf_name
}