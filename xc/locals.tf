locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  origin_bigip = "${data.tfe_outputs.bigip.values.origin_souce == "bigip" ? data.tfe_outputs.bigip.values.public_vip : ""}"
  origin_nap = "${data.tfe_outputs.nap.values.origin_souce == "nap" ? data.tfe_outputs.nap.values.external_name : "" }"
  origin_server = "${coalesce(local.origin_bigip, local.origin_nap)}"
  dns_origin_pool = "${data.tfe_outputs.nap.values.origin_souce == "nap" ? true : false }"
}