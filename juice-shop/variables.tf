#Global
variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
  default = ""
}
variable "resource_owner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
  default = ""
}
variable "build_suffix" {
  type = string
  description = "random id"
  default = ""
}

#AWS Global
variable "aws_region" {
  description = "aws region"
  type        = string
  default = ""
}
variable "azs" {
  description = "Availability Zones"
  type        = list
}
variable "vpc_id" {
  type        = string
  description = "The AWS network VPC ID"
  default     = ""
}
variable "vpc_main_route_table_id" {
  type = string
  description = "Main route table id"
  default =  ""
}
variable "private_cidr_blocks" {
  type        = list(any)
  default     = ["10.1.20.0/24", "10.1.120.0/24"]
  description = "Internal subnet address prefixes"
}
variable "app_cidr" {
  type = string
  default = ""
}
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}
variable "internal_sg_id" {
  type        = string
  description = "Internal securitiy group ID"
  default     = ""
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
