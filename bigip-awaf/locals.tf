locals {
  #GLOBAL
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  aws_region = data.tfe_outputs.infra.values.aws_region
  resource_owner = data.tfe_outputs.infra.values.resource_owner

  #BIGIP
  bigip_password = data.tfe_outputs.bigip-base.values.bigip_password
  bigip_address = data.tfe_outputs.bigip-base.values.bigip_mgmt_ip

  #Juice
  juice_shop_ip = try(data.tfe_outputs.juiceshop.values.juice_shop_ip, "")
}