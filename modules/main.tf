#AWS Infra
module infra {
  count        = var.create_infra ? 1 : 0
  source       = "./infra"
  aws_region = var.aws_region
  azs = var.azs
  admin_src_addr = var.admin_src_addr
  project_prefix = var.project_prefix
  resource_owner = var.resource_owner
  build_suffix = var.build_suffix
}

#BIG-IP
module bigip {
  count        = var.create_bigip ? 1 : 0
  source       = "./bigip"
  project_prefix = var.project_prefix
  resource_owner = var.resource_owner
  build_suffix = var.build_suffix
  aws_region = var.aws_region
  vpc_id = local.vpc_id
  vpc_cidr_block = local.vpc_cidr_block
  extSubnetAz1 = local.extSubnetAz1
  intSubnetAz1 = local.intSubnetAz1
  mgmtSubnetAz1 = local.mgmtSubnetAz1
  external_sg_id = local.external_sg_id
  management_sg_id = local.management_sg_id
  internal_sg_id = local.internal_sg_id
  admin_src_addr = var.admin_src_addr
  private_az1_cidr_block = local.private_az1_cidr_block
  public_az1_cidr_block = local.public_az1_cidr_block
  f5_ami_search_name = var.f5_ami_search_name
  ssh_key = var.ssh_key
  f5_username = var.f5_username
  f5_password = local.f5_password
  create_awaf_config = var.create_awaf_config
  awaf_config_payload = var.awaf_config_payload
  create_ltm_config = var.create_ltm_config
  ltm_config_payload = var.ltm_config_payload
  juice_shop_ip = local.juice_shop_ip
}

module juice_shop {
  count = var.create_juice_shop ? 1 : 0
  source = "./juice-shop"
  project_prefix = var.project_prefix
  resource_owner = var.resource_owner
  build_suffix = var.build_suffix
  aws_region = var.aws_region
  azs = var.azs
  vpc_id = local.vpc_id
  internal_sg_id = local.internal_sg_id
  private_cidr_blocks = local.private_cidr_blocks
  private_subnet_ids = local.private_subnet_ids
  public_subnet_ids = local.public_subnet_ids
  app_cidr = local.app_cidr
  vpc_main_route_table_id = local.vpc_main_route_table_id
  ssh_key = var.ssh_key
}
#XC
module xc_lb {
  count = var.create_xc_lb ? 1 : 0
  source = "./xc-lb"
  project_prefix = var.project_prefix
  build_suffix = var.build_suffix
  api_url = var.api_url
  api_cert = var.api_cert
  api_key = var.api_key
  xc_namespace = var.xc_namespace
  app_domain = var.app_domain
  dns_origin_pool = local.dns_origin_pool
  origin_server_dns_name = local.origin_server_dns_name
  origin_server_ip_address = local.origin_server_ip_address
  xc_waf_name = local.xc_waf_name
}

#XC WAF
module "xc_waf" {
  count = var.create_xc_waf ? 1 : 0
  source = "./xc-waf"
  project_prefix = var.project_prefix
  build_suffix = var.build_suffix
  api_url = var.api_url
  api_cert = var.api_cert
  api_key = var.api_key
  xc_namespace = var.xc_namespace
  xc_waf_blocking = var.xc_waf_blocking
}
