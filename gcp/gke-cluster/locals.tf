locals {
  project_id      = data.tfe_outputs.infra.values.project_id
  region          = data.tfe_outputs.infra.values.region
  network_name    = data.tfe_outputs.infra.values.vpc_name
  subnet_name     = data.tfe_outputs.infra.values.subnet_name
  project_prefix  = data.tfe_outputs.infra.values.project_prefix
  build_suffix    = data.tfe_outputs.infra.values.build_suffix
}
