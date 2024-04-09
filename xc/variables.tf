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
variable "xc_tenant" {
  type        = string
  description = "Your F5 XC tenant name"
}
variable "api_url" {
  type        = string
  description = "Your F5 XC tenant api url"
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
  type        = list(any)
  description = "Set Apptype for shared AI/ML"
  default     = null
}
variable "xc_multi_lb" {
  type        = string
  description = "ML configured externally using app type feature and label added to the HTTP load balancer."
  default     = "false"
}
#XC API Protection and Discovery
variable "xc_api_disc" {
  type        = string
  description = "Enable API Discovery on single LB"
  default     = "false"
}
variable "xc_api_pro" {
  type        = string
  description = "Enable API Protection (Definition and Rules)"
  default     = "false"
}
variable "xc_api_spec" {
  type        = list(any)
  description = "XC object store path to swagger spec ex: https://my.tenant.domain/api/object_store/namespaces/my-ns/stored_objects/swagger/file-name/v1-22-01-12"
  default     = null
}
variable "xc_api_val" {
  type        = string
  description = "Enable API Validation"
  default     = "false"
}
variable "xc_api_val_all" {
  type        = string
  description = "Enable API Validation on all endpoints"
  default     = "false"
}
variable "xc_api_val_properties" {
  type    = list(string)
  default = ["PROPERTY_QUERY_PARAMETERS", "PROPERTY_PATH_PARAMETERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_COOKIE_PARAMETERS", "PROPERTY_HTTP_HEADERS", "PROPERTY_HTTP_BODY"]

}
variable "xc_resp_val_properties" {
  type    = list(string)
  default = ["PROPERTY_HTTP_HEADERS", "PROPERTY_CONTENT_TYPE", "PROPERTY_HTTP_BODY", "PROPERTY_RESPONSE_CODE"]
}
variable "xc_api_val_active" {
  type        = string
  description = "Enable API Validation on active endpoints"
  default     = "false"
}
variable "xc_resp_val_active" {
  type        = string
  description = "Enable response API Validation on active endpoints"
  default     = "false"
}
variable "enforcement_block" {
  type        = string
  description = "Enable enforcement block"
  default     = "false"
}
variable "enforcement_report" {
  type        = string
  description = "Enable enforcement report"
  default     = "false"
}
variable "fall_through_mode_allow" {
  type        = string
  description = "Enable fall through mode allow"
  default     = "false"
}
variable "xc_api_val_custom" {
  type        = string
  description = "Enable API Validation custom rules"
  default     = "false"
}
#JWT Validation
variable "xc_jwt_val" {
  type        = string
  description = "Enable JWT Validation"
  default     = "false"
}
variable "jwt_val_block" {
  type        = string
  description = "Enable JWT Validation block"
  default     = "false"
}
variable "jwt_val_report" {
  type        = string
  description = "Enable JWT Validation report"
  default     = "false"
}
variable "jwks" {
  type        = string
  description = "JWK for validation"
  default     = "app_domain" 
}
variable "iss_claim" {
  type        = string
  description = "JWT Validation issuer claim"
  default     = "true"
}
variable "aud_claim" {
  type        = list(string)
  description = "JWT Validation audience claim"
  default     = [""]
}
variable "exp_claim" {
  type        = string
  description = "JWT Validation expiration claim"
  default     = "true"
}

#XC Bot Defense
variable "xc_bot_def" {
  type        = string
  description = "Enable XC Bot Defense"
  default     = "false"
}
#XC DDoS Protection
variable "xc_ddos_pro" {
  type        = string
  description = "Enable XC DDoS Protection"
  default     = "false"
}
#XC Malicious User Detection
variable "xc_mud" {
  type        = string
  description = "Enable Malicious User Detection on single LB"
  default     = "false"
}

