locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  origin_server_ip_address = data.tfe_outputs.bigip.values.public_vip
}