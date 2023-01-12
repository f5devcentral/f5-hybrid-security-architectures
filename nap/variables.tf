#TF Cloud
variable "tf_cloud_organization" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#NIGNX
variable nginx_registry {
    type = string
    description = "NGINX docker regstery"
    default = "private-registry.nginx.com"
}
variable nginx_jwt {
    type = string
    description = "JWT for pulling NGINX image"
    default = "nginx_repo.jwt"
}
variable "ssh_key" {
  type        = string
  description = "Unneeded for NAP, only present for warning handling with TF cloud variable set"
}