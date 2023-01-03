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
#XC Global
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
#XC WAF
variable "xc_waf_name" {
  type = string
  description = "The name of the WAF policy created"
  default = null
}
variable "xc_waf_blocking" {
  type = string
  description = "Set XC WAF to Blocking(true) or Monitoring(false)"
  default = "false"
}

