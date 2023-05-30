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

#CIS Config
variable "create_cis_config" {
  type        = bool
  default     = false
  description = "Set to true to create CIS config"
}
variable "cis_config_payload" {
    type        = string
    description = "CIS Config AS3"
    default     = "/path/to/as/file"
}
variable "irule_config_payload" {
    type        = string
    description = "iRule Config AS3"
    default     = "irule-config.json"
}
variable "bigip_k8s_partition" {
    type        = string
    description = "the partition (AS3 tenant) in which the ingress virtual servers will be created"
}
