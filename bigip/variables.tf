# Variables
#Global
variable "project_prefix" {
  type        = string
  default     = "demo"
  description = "This value is inserted at the beginning of each AWS object (alpha-numeric, no special character)"
}
variable "build_suffix" {
  type = string
  description = "random id"
  default = ""
}
variable "admin_src_addr" {
  type        = string
  description = "Allowed Admin source IP prefix"
  default     = "0.0.0.0/0"
}
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#AWS
variable "aws_region" {
  description = "aws region"
  type        = string
  default     = "us-west-2"
}
variable "awsAz1" {
  description = "Availability zone, will dynamically choose one if left empty"
  type        = string
  default     = "us-west-2a"
}
variable "vpc_id" {
  type        = string
  description = "The AWS network VPC ID"
  default     = null
}
variable "vpc_cidr_block" {
  type        = string
  description = "The AWS network VPC CIDR block"
  default     = null
}
variable "mgmt_subnet_az1" {
  type        = string
  description = "ID of Management subnet AZ1"
  default     = null
}
variable "ext_subnet_az1" {
  type        = string
  description = "ID of External subnet AZ1"
  default     = null
}
variable "int_subnet_az1" {
  type        = string
  description = "ID of Internal subnet AZ1"
  default     = null
}
variable "public_az1_cidr_block" {
  type        = string
  description = "CIDR of External subnet AZ1"
  default     = null
}
variable "private_az1_cidr_block" {
  type        = string
  description = "CIDR of Internal subnet AZ1"
  default     = null
}
variable "external_sg_id" {
  type        = string
  description = "ID of external security group"
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
variable "f5_ami_search_name" {
  type        = string
  description = "AWS AMI search filter to find correct BIG-IP VE for region"
  default     = "F5 BIGIP-16.1.3.2* PAYG-Best Plus 200Mbps*"
}
variable "ec2_instance_type" {
  type        = string
  description = "AWS instance type for the BIG-IP"
  default     = "m5n.xlarge"
}
variable "ec2_key_name" {
  type        = string
  description = "AWS EC2 Key name for SSH access"
  default     = null
}
#BIG-IP
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
variable "aws_secretmanager_auth" {
  description = "Whether to use secret manager to pass authentication"
  type        = bool
  default     = false
}
variable "aws_secretmanager_secret_id" {
  description = "The ARN of Secrets Manager secret with BIG-IP password"
  type        = string
  default     = null
}
variable "aws_iam_instance_profile" {
  description = "Name of IAM role to assign to the BIG-IP instance"
  type        = string
  default     = null
}
variable "license1" {
  type        = string
  default     = ""
  description = "The license token for the 1st F5 BIG-IP VE (BYOL)"
}
variable "dns_server" {
  type        = string
  default     = "8.8.8.8"
  description = "Leave the default DNS server the BIG-IP uses, or replace the default DNS server with the one you want to use"
}
variable "ntp_server" {
  type        = string
  default     = "0.us.pool.ntp.org"
  description = "Leave the default NTP server the BIG-IP uses, or replace the default NTP server with the one you want to use"
}
variable "timezone" {
  type        = string
  default     = "UTC"
  description = "If you would like to change the time zone the BIG-IP uses, enter the time zone you want to use. This is based on the tz database found in /usr/share/zoneinfo (see the full list [here](https://github.com/F5Networks/f5-azure-arm-templates/blob/master/azure-timezone-list.md)). Example values: UTC, US/Pacific, US/Eastern, Europe/London or Asia/Singapore."
}
variable "DO_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.34.0/f5-declarative-onboarding-1.34.0-5.noarch.rpm"
  description = "URL to download the BIG-IP Declarative Onboarding module"
}
variable "AS3_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.41.0/f5-appsvcs-3.41.0-1.noarch.rpm"
  description = "URL to download the BIG-IP Application Service Extension 3 (AS3) module"
}
variable "TS_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-telemetry-streaming/releases/download/v1.32.0/f5-telemetry-1.32.0-2.noarch.rpm"
  description = "URL to download the BIG-IP Telemetry Streaming module"
}
variable "FAST_URL" {
  type        = string
  default     = "https://github.com/F5Networks/f5-appsvcs-templates/releases/download/v1.22.0/f5-appsvcs-templates-1.22.0-1.noarch.rpm"
  description = "URL to download the BIG-IP FAST module"
}
variable "INIT_URL" {
  type        = string
  default     = "https://cdn.f5.com/product/cloudsolutions/f5-bigip-runtime-init/v1.5.1/dist/f5-bigip-runtime-init-1.5.1-1.gz.run"
  description = "URL to download the BIG-IP runtime init"
}
variable "libs_dir" {
  type        = string
  default     = "/config/cloud/aws/node_modules"
  description = "Directory on the BIG-IP to download the A&O Toolchain into"
}
variable "resource_owner" {
  type        = string
  default     = null
  description = "This is a tag used for object creation. Example is last name."
}
#AWAF Config
variable "create_awaf_config" {
  type        = bool
  default     = false
  description = "Set to true to create AWAF config"
}
variable "awaf_config_payload" {
    type        = string
    description = "AWAF Policy AS3"
    default     = "/path/to/as/file"
}
#LTM Only Config
variable "create_ltm_config" {
  type        = bool
  default     = false
  description = "Set to true to create LTM only config"
}
variable "ltm_config_payload" {
    type        = string
    description = "LTM Config AS3"
    default     = "/path/to/as/file"
}
#App Server
variable "juice_shop_ip" {
  default = null
}