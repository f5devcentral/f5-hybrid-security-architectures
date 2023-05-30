# BIG-IP

# Create F5 BIG-IP VMs
module "bigip" {
  source                     = "F5Networks/bigip-module/aws"
  version                    = "1.1.10"
  prefix                      = format("%s-3nic", local.project_prefix)
  ec2_instance_type          = var.ec2_instance_type
  ec2_key_name               = aws_key_pair.bigip.key_name
  f5_ami_search_name         = var.f5_ami_search_name
  f5_username                = var.f5_username
  aws_iam_instance_profile    = var.aws_iam_instance_profile == null ? aws_iam_instance_profile.bigip_profile[0].name : var.aws_iam_instance_profile
  mgmt_subnet_ids            = [{ "subnet_id" = local.mgmt_subnet_az1, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  mgmt_securitygroup_ids     = [local.management_sg_id]
  external_subnet_ids        = [{ "subnet_id" = local.ext_subnet_az1, "public_ip" = true, "private_ip_primary" = "", "private_ip_secondary" = "" }]
  external_securitygroup_ids = [local.external_sg_id]
  internal_subnet_ids        = [{ "subnet_id" = local.int_subnet_az1, "public_ip" = false, "private_ip_primary" = "" }]
  internal_securitygroup_ids = [local.internal_sg_id]
  custom_user_data           = local.f5_onboard1
  sleep_time                 = "30s"
  tags                       = local.tags
}

resource "random_string" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}
