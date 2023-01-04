#Global
project_prefix = ""
resource_owner = ""
build_suffix = ""

#AWS INFRA
aws_region     = "us-east-1"
azs           = ["us-east-1a", "us-east-1b"]
#public_subnet_ids = data.tf_outputs.infra.values.public_subnet_ids
#private_subnet_ids = data.tf_outputs.infra.values.private_subnet_ids
vpc_main_route_table_id  = ""
internal_sg_id = ""
#private_cidr_blocks = data.tf_outputs.infra.values.private_cidr_blocks
#public_cidr_blocks = data.tf_outputs.infra.values.public_cidr_blocks
app_cidr = ""

