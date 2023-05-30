#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
variable "ssh_key" {
  type        = string
  description = "Unneeded for brewz, only present for warning handling with TF cloud variable set"
}