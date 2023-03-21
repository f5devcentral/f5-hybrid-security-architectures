module "postbuild-config-cis" {
  source  = "f5devcentral/postbuild-config/bigip//as3"
  version = "0.6.3"
  count = var.create_cis_config ? 1 : 0
  bigip_user       = var.f5_username
  bigip_password   = var.aws_secretmanager_auth ? "" : random_string.password.result
  bigip_address    = module.bigip.mgmtPublicIP
  bigip_as3_payload = templatefile(var.cis_config_payload,
  {
  bigip_k8s_partition = local.bigip_k8s_partition
  }
  )
}