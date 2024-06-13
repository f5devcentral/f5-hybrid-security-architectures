locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  origin_bigip = try(data.tfe_outputs.bigip[0].values.bigip_public_vip, "")
  origin_nginx = try(data.tfe_outputs.nap[0].values.external_name, data.tfe_outputs.nic[0].values.external_name, "")
  origin_server = "${coalesce(local.origin_bigip, local.origin_nginx, var.serviceName)}"
  origin_port = try(data.tfe_outputs.nap[0].values.external_port, data.tfe_outputs.nic[0].values.external_port, "80")
  dns_origin_pool = local.origin_nginx != "" ? true : false 
}