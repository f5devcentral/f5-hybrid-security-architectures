locals {
  project_prefix = data.tf_outputs.infra.values.project_prefix
  resource_owner = data.tf_outputs.infra.values.resource_owner
  build_suffix = data.tf_outputs.infra.values.build_suffix
  aws_region = data.tf_outputs.infra.values.aws_region
  azs = data.tf_outputs.infra.values.azs
  vpc_id  = data.tf_outputs.infra.values.vpc_id
  vpc_main_route_table_id =  data.tf_outputs.infra.values.vpc_main_route_table_id
  app_cidr = data.tf_outputs.infra.values.app_cidr
  internal_sg_id = data.tf_outputs.infra.values.internal_sg_id
}
