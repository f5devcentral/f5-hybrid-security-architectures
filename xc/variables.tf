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
#XC AI/ML Settings for MUD, APIP - NOTE: Only set if using AI/ML settings from the shared namespace
variable "xc_app_type" {
  type = list
  description = "Set Apptype for shared AI/ML"
  default = null
}
variable "xc_multi_lb" {
  type        = string
  description = "ML configured externally using app type feature and label added to the HTTP load balancer."
  default     = "false"
}
#XC API Protection and Discovery
variable "xc_api_disc" {
  type       = string
  description = "Enable API Discovery on single LB"
  default     = "false"
}
variable "xc_api_def" {
  type       = string
  description = "Enable API Definition"
  default     = "false"
}
variable "xc_api_spec" {
  type       = list
  description = "XC object store path to swagger spec ex: https://my.tenant.domain/api/object_store/namespaces/my-ns/stored_objects/swagger/file-name/v1-22-01-12"
  default     = null
}
#XC Malicious User Detection
variable "xc_mud" {
  type       = string
  description = "Enable Malicious User Detection on single LB"
  default     = "false"
}

