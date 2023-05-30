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

#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
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

#AWAF Config
variable "create_apm_config" {
  type        = bool
  default     = false
  description = "Set to true to create APM config"
}
variable "apm_config_payload" {
    type        = string
    description = "APM Policy AS3"
    default     = "/path/to/as/file"
}

#App Server
variable "juice_shop_ip" {
  default = null
}