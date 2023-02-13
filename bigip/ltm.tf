module "postbuild-config-ltm" {
  source  = "f5devcentral/postbuild-config/bigip//as3"
  version = "0.6.3"
  count = var.create_ltm_config ? 1 : 0
  bigip_user       = var.f5_username
  bigip_password   = var.aws_secretmanager_auth ? "" : random_string.password.result
  bigip_address    = module.bigip.mgmtPublicIP
  bigip_as3_payload = templatefile(var.ltm_config_payload,
  {
  juice_shop_ip = local.juice_shop_ip
  }
  )
}