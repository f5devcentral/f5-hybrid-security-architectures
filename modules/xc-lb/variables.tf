#Project Globals
variable "project_prefix" {
  type        = string
  default     = "demo"
  description = "This value is inserted at the beginning of each object (alpha-numeric, no special character)"
}
variable "build_suffix" {
  description = "random id"
  type = string
}
#XC Globals
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
#variable "xc_lb_name" {
#  type = string
#  description = "Name of the created XC LB"
#}
variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}
variable "dns_origin_pool" {
  type        = bool
  description = "Set to true for dns fqdn XC origin pool, set to false for IP XC origin pool"
  default     = true
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
#XC WAF
variable "xc_waf_name" {
  type = string
  description = "The name of the WAF policy created"
  default = null
}


