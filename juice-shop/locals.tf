locals {
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  resource_owner = data.tfe_outputs.infra.values.resource_owner
  build_suffix = data.tfe_outputs.infra.values.build_suffix
  aws_region = data.tfe_outputs.infra.values.aws_region
  azs = data.tfe_outputs.infra.values.azs
  vpc_id  = data.tfe_outputs.infra.values.vpc_id
  vpc_main_route_table_id =  data.tfe_outputs.infra.values.vpc_main_route_table_id
  app_cidr = data.tfe_outputs.infra.values.app_cidr
  internal_sg_id = data.tfe_outputs.infra.values.internal_sg_id
}
