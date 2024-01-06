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
#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
## SSH Key
variable "ssh_key" {
  type        = string
  description = "public key used for authentication in ssh-rsa format"
}
