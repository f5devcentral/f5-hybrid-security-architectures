#Project Globals
variable "project_prefix" {
  type        = string
  default     = "demo"
  description = "This value is inserted at the beginning of each object (alpha-numeric, no special character)"
}
variable "resource_owner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
# default     = "myName"
}
variable "build_suffix" {
  description = "random id"
  type = string
}
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}

#AWS
variable "vpc_id" {
  type        = string
  description = "The AWS network VPC ID"
  default     = null
}
variable "vpc_main_route_table_id" {
  type = string
  description = "Main route table id"
}
variable "eks_cidr" {
  type = string
}

/*
variable "public_cidr_blocks" {
  type        = list(any)
  default     = ["10.1.10.0/24", "10.1.110.0/24"]
  description = "External subnet address prefixes"
}
variable "private_cidr_blocks" {
  type        = list(any)
  default     = ["10.1.20.0/24", "10.1.120.0/24"]
  description = "Internal subnet address prefixes"
}
*/

variable "public_subnet_ids" {
  type = list(any)
}

variable "azs" {
  description = "Availability Zones"
  type        = list
}
variable "eks_addons" {
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "kube-proxy"
      version = "v1.23.13-eksbuild.2"
    },
    {
      name    = "vpc-cni"
      version = "v1.12.0-eksbuild.1"
    },
    {
      name    = "coredns"
      version = "v1.8.7-eksbuild.3"
    },
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.13.0-eksbuild.3"
    }
  ]
}











