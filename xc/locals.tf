locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  origin_bigip = try(data.tfe_outputs.bigip.values.bigip_public_vip, "")
  origin_nap = try(data.tfe_outputs.nap.values.external_name, "")
  origin_server = "${coalesce(local.origin_bigip, local.origin_nap)}"
  origin_port = try(data.tfe_outputs.nap.values.external_port, "80")
  dns_origin_pool = local.origin_nap != "" ? true : false 
}