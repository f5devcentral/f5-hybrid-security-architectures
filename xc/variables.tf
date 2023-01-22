#TF Cloud
variable "tf_cloud_organization" {
  type        = string
  description = "TF cloud org (Value set in TF cloud)"
}
variable "ssh_key" {
  type        = string
  description = "Unneeded for XC, only present for warning handling with TF cloud variable set"
}
#XC
variable "api_url" {
  type         = string
  description = "Your F5 XC tenant"
}
variable "xc_namespace" {
  type        = string
  description = "Volterra app namespace where the object will be created. This cannot be system or shared ns."
}
variable "app_domain" {
  type        = string
  description = "FQDN for the app. If you have delegated domain `prod.example.com`, then your app_domain can be `<app_name>.prod.example.com`"
}
#XC WAF
variable "xc_waf_blocking" {
  type        = string
  description = "Set XC WAF to Blocking(true) or Monitoring(false)"
  default     = "false"
}
#XF MUD
variable "xc_mud" {
  type        = string
  description = "Enable Malicious User Detection"
  default     = "false"
}
variable "xc_mud_custom" {
  type        = string
  description = "Malicious User Detection custom settings"
  default     = "false"
}

