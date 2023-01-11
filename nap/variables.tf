#TF Cloud
variable "tf_cloud_organzation" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#NIGNX
variable nginx_registry {
    type = string
    description = "NGINX docker regstery"
}
variable nginx_jwt {
    type = string
    description = "JWT for pulling NGINX image"
}
