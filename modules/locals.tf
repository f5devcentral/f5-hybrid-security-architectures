#LOCALS
locals {
  vpc_id            = var.create_infra ? module.infra[0].vpc_id : data.aws_vpc.default[0].id
  vpc_cidr_block   = var.create_infra ? module.infra[0].vpc_cidr_block : data.aws_vpc.default[0].cidr_block
  extSubnetAz1     = var.create_infra ? module.infra[0].extSubnetAz1 : var.extSubAz1
  extSubnetAz2     = var.create_infra ? module.infra[0].extSubnetAz2 : var.extSubAz2
  intSubnetAz1     = var.create_infra ? module.infra[0].intSubnetAz1 : var.intSubnetAz1
  intSubnetAz2     = var.create_infra ? module.infra[0].intSubnetAz2 : var.intSubAz2
  mgmtSubnetAz1    = var.create_infra ? module.infra[0].mgmtSubnetAz1 : var.mgmtSubAz1
  mgmtSubnetAz2    = var.create_infra ? module.infra[0].mgmtSubnetAz2 : var.mgmtSubAz2
  external_sg_id   = var.create_infra ? module.infra[0].external_sg_id : var.external_sg_id
  management_sg_id   = var.create_infra ? module.infra[0].management_sg_id : var.management_sg_id
  internal_sg_id   = var.create_infra ? module.infra[0].internal_sg_id : var.internal_sg_id
  vpc_main_route_table_id = var.create_infra ? module.infra[0].vpc_main_route_table_id : var.route_table_id
  public_cidr_blocks = var.create_infra ? module.infra[0].public_cidr_blocks : var.public_cidr_blocks
  private_cidr_blocks = var.create_infra ? module.infra[0].private_cidr_blocks : var.private_cidr_blocks
  #management_cidr_blocks = var.create_infra ? module.infra[0].private_cidr_blocks : var.management_cidr_blocks
  public_subnet_ids = var.create_infra ? module.infra[0].public_subnet_ids : var.public_subnet_ids
  private_subnet_ids = var.create_infra ? module.infra[0].private_subnet_ids : var.private_subnet_ids
  public_az1_cidr_block = var.create_infra ? module.infra[0].public_az1_cidr_block : var.public_az1_cidr_block
  private_az1_cidr_block = var.create_infra ? module.infra[0].private_az1_cidr_block : var.private_az1_cidr_block
  app_cidr = var.create_infra ? module.infra[0].app_cidr : var.app_cidr
  f5_password = var.create_bigip ? module.bigip[0].f5_password : var.f5_password
  origin_server_dns_name   = var.create_bigip ? module.bigip[0].public_vip_url : var.origin_server_dns_name
  origin_server_ip_address   = var.create_bigip ? module.bigip[0].public_vip : var.origin_server_ip_address
  dns_origin_pool  = var.create_bigip ? false : var.dns_origin_pool
  mgmt_ip = var.create_bigip ? module.bigip[0].f5vm01_mgmt_public_ip : var.bigipmgmt
  xc_waf_name = var.create_xc_waf ? module.xc_waf[0].xc_waf_name : var.xc_waf_name
  juice_shop_ip = var.create_juice_shop ? module.juice_shop[0].juice_shop_ip : var.juice_shop_ip
}