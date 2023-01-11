#TF Cloud
variable "tf_cloud_organzation" {
  type = string
  description = "TF cloud org (Value set in TF cloud)"
}
#XC
variable "api_url" {
  type = string
  default = "https://YOUR_TENANT.console.ves.volterra.io/api"
}
variable "xc_namespace" {
  type = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}
variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}
#XC WAF
variable "xc_waf_blocking" {
  type = string
  description = "Set XC WAF to Blocking(true) or Monitoring(false)"
  default = "false"
}


