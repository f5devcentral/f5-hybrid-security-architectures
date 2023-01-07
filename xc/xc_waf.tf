# ---------------------------------------------------------------------------- #
# Create XC WAAP WAF config
# ---------------------------------------------------------------------------- #

resource "volterra_app_firewall" "waap-tf" {
  name                     = format("%s-xcw-%s", local.project_prefix, local.build_suffix)
  description              = format("WAF in block mode for %s", "${local.project_prefix}-xcw-${local.build_suffix}")
  namespace                = var.xc_namespace

  // One of the arguments from this list "allow_all_response_codes allowed_response_codes" must be set
  allow_all_response_codes = true
  // One of the arguments from this list "default_anonymization custom_anonymization disable_anonymization" must be set
  default_anonymization = true
  // One of the arguments from this list "use_default_blocking_page blocking_page" must be set
  use_default_blocking_page = true
  // One of the arguments from this list "default_bot_setting bot_protection_setting" must be set
  default_bot_setting = true
  // One of the arguments from this list "default_detection_settings detection_settings" must be set
  default_detection_settings = true
  // One of the arguments from this list "use_loadbalancer_setting blocking monitoring" must be set
  use_loadbalancer_setting = true
  // Blocking mode - optional - if not set, policy is in MONITORING
  blocking = var.xc_waf_blocking
}
