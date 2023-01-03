#Project Globals
variable "project_prefix" {
  type        = string
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
}
variable "resource_owner" {
  type        = string
  description = "owner of the deployment, for tagging purposes"
}
variable "build_suffix" {
  type = string
  description = "random id"
}

#ONBOARDING
variable "create_infra" {
  type        = bool
  default     = false
  description = "Set to true to create infra"
}
variable "create_nat_gateway" {
  type        = bool
  default     = false
  description = "Programatically set to false if NG has been created in another module"
}
variable "create_bigip" {
  type        = bool
  default     = false
  description = "Set to true to create BIG-IP"
}
variable "create_ltm_config" {
  type        = bool
  default     = false
  description = "Set to true to create LTM VIP"  
}
variable "create_awaf_config" {
  type        = bool
  default     = false
  description = "Set to true to create AWAF config"
}
variable "create_juice_shop" {
  type        = bool
  default     = false
  description = "Set to true to create ec2 app server"
}
variable "create_xc_lb" {
  type        = bool
  default     = false
  description = "Set to true to create XC LB"
}
variable "create_xc_waf" {
  type        = bool
  default     = false
  description = "Set to true to create XC WAF Policy"
}

#AWS INFRA
variable "aws_region" {
  description = "aws region"
  type        = string
#  default     = "us-west-2"
}
variable azs {
  description = "Availability Zones"
  type        = list
  default     = ["us-west-1a", "us-west-1b"]
}
variable "public_subnet_ids" {
  type = list(any)
  description = "Required for deploying an EKS cluster(separate terraform project) to VPC if create_infra is true and create_juice_shop is false"
}
variable "mgmtSubAz1" {
  type        = string
  description = "ID of Management subnet AZ1"
  default     = null
}
variable "mgmtSubAz2" {
  type        = string
  description = "ID of Management subnet AZ1"
  default     = null
}
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}
variable "extSubAz2" {
  type        = string
  description = "ID of External subnet AZ2"
  default     = null
}
variable "extSubAz1" {
  type        = string
  description = "ID of External subnet AZ1"
  default     = null
}
variable "intSubAz1" {
  type        = string
  description = "ID of Internal subnet AZ1"
  default     = null
}
variable "intSubAz2" {
  type        = string
  description = "ID of Internal subnet AZ1"
  default     = null
}
variable "external_sg_id" {
  type        = string
  description = "External securitiy group ID"
  default     = null
}
variable "management_sg_id" {
  type        = string
  description = "Management securitiy group ID"
  default     = null
}
variable "internal_sg_id" {
  type        = string
  description = "Internal securitiy group ID"
  default     = null
}

#BIG-IP
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
variable "f5vm01_mgmt_public_ip" {
  type        = string
  description = "BIG-IP managment IP"
  default     = "1.1.1.1"       
}
variable "bigipmgmt" {
  type        = string
  description = "BIG-IP managment IP"
  default     = null       
}
variable "f5_username" {
  type        = string
  description = "User name for the BIG-IP (Note: currenlty not used. Defaults to 'admin' based on AMI"
  default     = "admin"
}
variable "f5_password" {
  type        = string
  description = "BIG-IP Password or Secret ARN (value should be ARN of secret when aws_secretmanager_auth = true, ex. arn:aws:secretsmanager:us-west-2:1234:secret:bigip-secret-abcd)"
  default     = "Default12345!"
}
variable "f5_ami_search_name" {
  type        = string
  description = "AWS AMI search filter to find correct BIG-IP VE for region"
  default     = "F5 BIGIP-16.1.3* PAYG-Adv WAF Plus 25Mbps*"
}
variable "vip_url" {
  type        = string
  description = "VIP on Big-IP"
  default     = null
}

#BIG-IP LTM VIP
variable "ltm_config_payload" {
    type        = string
    description = "LTM only config AS3"
    default     = "/path/to/as3/file"
}

#AWAF Policy
variable "awaf_config_payload" {
    type        = string
    description = "AWAF config AS3"
    default     = "/path/to/as/file"
}

#App Server
variable "juice_shop_ip" {
    type = string
}

#XC
variable "api_cert" {
  type = string
  default = "/PATH/certificate.cert"
}    
variable "api_key" {
  type = string
  default = "/PATH/private_key.key"
}
variable "api_url" {
  type = string
  default = "https://YOUT_TENANT.console.ves.volterra.io/api"
}
variable "xc_namespace" {
  type = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}

#XC LB
variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}
variable "origin_server_dns_name" {
  type        = string
  description = "Origin server's publicly resolvable dns name"
  default     = "www.f5.com"
}
variable "origin_server_ip_address" {
  type        = string
  description = "Origin server's public IP address"
  default     = "0.0.0.0"
}
variable "dns_origin_pool" {
  type        = bool
  description = "Set to true for dns fqdn XC origin pool, set to false for IP XC origin pool"
  default     = true
}

#XC WAF
variable "xc_waf_name" {
  type = string
  description = "Set to XC WAF policy name"
  default = "test-policy"
}
variable "xc_waf_blocking" {
  type = string
  default = "false"
}

variable "route_table_id" {}
variable "private_cidr_blocks" {}
variable "public_cidr_blocks" {}
#variable "management_cidr_blocks" {}
variable "private_subnet_ids" {}
variable "public_az1_cidr_block" {}
variable "private_az1_cidr_block" {}

variable "app_cidr" {
  type = string
  default = null
}
variable "extSubnetAz2" {
  type        = string
  description = "ID of External subnet AZ2"
  default     = null
}
variable "extSubnetAz1" {
  type        = string
  description = "ID of External subnet AZ1"
  default     = null
}
variable "intSubnetAz1" {
  type        = string
  description = "ID of Internal subnet AZ1"
  default     = null
}
variable "intSubnetAz2" {
  type        = string
  description = "ID of Internal subnet AZ1"
  default     = null
}