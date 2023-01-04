#Global
variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
  default = data.tf_outputs.infra.values.project_prefix
}
variable "resource_owner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
  default = data.tf_outputs.infra.values.resource_owner
}
variable "build_suffix" {
  type = string
  description = "random id"
  default = data.tf_outputs.infra.values.build_suffix
}

#AWS Global
variable "aws_region" {
  description = "aws region"
  type        = string
  default = data.tf_outputs.infra.values.aws_region
}
variable "azs" {
  description = "Availability Zones"
  type        = list
  default = data.tf_outputs.infra.values.azs
}
variable "vpc_id" {
  type        = string
  description = "The AWS network VPC ID"
  default     = data.tf_outputs.infra.values.vpc_id
}
variable "vpc_main_route_table_id" {
  type = string
  description = "Main route table id"
  default =  data.tf_outputs.infra.values.vpc_main_route_table_id
}
variable "private_cidr_blocks" {
  type        = list(any)
  default     = ["10.1.20.0/24", "10.1.120.0/24"]
  description = "Internal subnet address prefixes"
}
variable "app_cidr" {
  type = string
  default = data.tf_outputs.infra.values.app_cidr
}
#EC2
/*
variable "private_subnet_ids" {
  type = list(any)
}
variable "public_subnet_ids" {
  type = list(any)
}
*/
variable "internal_sg_id" {
  type        = string
  description = "Internal securitiy group ID"
  default     = data.tf_outputs.infra.values.internal_sg_id
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
