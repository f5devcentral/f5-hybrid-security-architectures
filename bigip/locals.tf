locals {
  #Global State Values 
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  resource_owner = data.tfe_outputs.infra.values.resource_owner
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  
  #Infra State Values
  aws_region = data.tfe_outputs.infra.values.aws_region
  vpc_cidr_block = data.tfe_outputs.infra.values.vpc_cidr_block
  public_az1_cidr_block = data.tfe_outputs.infra.values.public_az1_cidr_block
  private_az1_cidr_block = data.tfe_outputs.infra.values.private_az1_cidr_block
  private_eks_az1_cidr_block = try(data.tfe_outputs.eks.values.private_eks_az1_cidr_block, "")
  external_sg_id = data.tfe_outputs.infra.values.external_sg_id
  internal_sg_id = data.tfe_outputs.infra.values.internal_sg_id
  management_sg_id = data.tfe_outputs.infra.values.management_sg_id
  mgmt_subnet_az1 = data.tfe_outputs.infra.values.mgmt_subnet_az1
  int_subnet_az1 = data.tfe_outputs.infra.values.int_subnet_az1
  int_subnet_eks_az1 = try(data.tfe_outputs.eks.values.int_eks_subnet_az1, "")
  ext_subnet_az1 = data.tfe_outputs.infra.values.ext_subnet_az1

  #Juice State Values
  juice_shop_ip = data.tfe_outputs.juiceshop.values.juice_shop_ip

  # Retrieve all BIG-IP secondary IPs
  vm01_ext_ips = {
    0 = {
      ip = element(flatten(module.bigip.private_addresses["public_private"]["private_ips"][0]), 0)
    }
    1 = {
      ip = element(flatten(module.bigip.private_addresses["public_private"]["private_ips"][0]), 1)
    }
  }
  # Determine BIG-IP secondary IPs to be used for VIP
  vm01_vip_ips = {
    app1 = {
      ip = module.bigip.private_addresses["public_private"]["private_ip"][0] != local.vm01_ext_ips.0.ip ? local.vm01_ext_ips.0.ip : local.vm01_ext_ips.1.ip
    }
  }
  # Custom tags
  tags = {
    Owner = local.resource_owner
  }

  #Setup BIG-IP Onboarding
  f5_onboard1 = templatefile("f5_onboard.tmpl", {
    regKey                      = var.license1
    f5_username                 = var.f5_username
    f5_password                 = var.aws_secretmanager_auth ? "" : random_string.password.result
    aws_secretmanager_auth      = var.aws_secretmanager_auth
    aws_secretmanager_secret_id = var.aws_secretmanager_auth ? data.aws_secretsmanager_secret_version.current[0].secret_id : ""
    INIT_URL                    = var.INIT_URL
    DO_URL                      = var.DO_URL
    AS3_URL                     = var.AS3_URL
    TS_URL                      = var.TS_URL
    FAST_URL                    = var.FAST_URL
    DO_VER                      = split("/", var.DO_URL)[7]
    AS3_VER                     = split("/", var.AS3_URL)[7]
    TS_VER                      = split("/", var.TS_URL)[7]
    FAST_VER                    = split("/", var.FAST_URL)[7]
    vpc_cidr_block              = local.vpc_cidr_block
    internal_netmask            = split("/",  local.private_az1_cidr_block)[1]
    external_netmask            = split("/",  local.public_az1_cidr_block)[1]
    dns_server                  = var.dns_server
    ntp_server                  = var.ntp_server
    timezone                    = var.timezone
  })


  #Setup BIG-IP CIS Onboarding
  f5_onboard_cis = templatefile("f5_onboard_cis.tmpl", {
    regKey                      = var.license1
    f5_username                 = var.f5_username
    f5_password                 = var.aws_secretmanager_auth ? "" : random_string.password.result
    aws_secretmanager_auth      = var.aws_secretmanager_auth
    aws_secretmanager_secret_id = var.aws_secretmanager_auth ? data.aws_secretsmanager_secret_version.current[0].secret_id : ""
    INIT_URL                    = var.INIT_URL
    DO_URL                      = var.DO_URL
    AS3_URL                     = var.AS3_URL
    TS_URL                      = var.TS_URL
    FAST_URL                    = var.FAST_URL
    DO_VER                      = split("/", var.DO_URL)[7]
    AS3_VER                     = split("/", var.AS3_URL)[7]
    TS_VER                      = split("/", var.TS_URL)[7]
    FAST_VER                    = split("/", var.FAST_URL)[7]
    vpc_cidr_block              = local.vpc_cidr_block
    internal_netmask            = split("/",  local.private_eks_az1_cidr_block)[1]
    external_netmask            = split("/",  local.public_az1_cidr_block)[1]
    dns_server                  = var.dns_server
    ntp_server                  = var.ntp_server
    timezone                    = var.timezone
  })
}