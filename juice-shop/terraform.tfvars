#Global
project_prefix = data.tf_outputs.infra.values.project_prefix
resource_owner = data.tf_outputs.infra.values.resource_owner
build_suffix = data.tf_outputs.infra.values.build_suffix

#AWS INFRA
aws_region     = data.tf_outputs.infra.values.aws_region
azs           = data.tf_outputs.infra.values.azs
#public_subnet_ids = data.tf_outputs.infra.values.public_subnet_ids
#private_subnet_ids = data.tf_outputs.infra.values.private_subnet_ids
vpc_main_route_table_id  = data.tf_outputs.infra.values.vpc_main_route_table_id
internal_sg_id = data.tf_outputs.infra.values.internal_sg_id
#private_cidr_blocks = data.tf_outputs.infra.values.private_cidr_blocks
#public_cidr_blocks = data.tf_outputs.infra.values.public_cidr_blocks
app_cidr = data.tf_outputs.infra.values.app_cidr

