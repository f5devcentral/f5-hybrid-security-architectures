resource "volterra_app_type" "mud-app-type" {
  count = var.xc_mud_custom ? 1 : 0
  name = format("%s-mud-app-%s", local.project_prefix, local.build_suffix)
  namespace = "shared"
  features {  
        type = "USER_BEHAVIOR_ANALYSIS"   
  }
  business_logic_markup_setting {
      enable = true
    }
}

resource "volterra_app_setting" "mud-app-settings" {
  name = format("%s-mud-app-set-%s", local.project_prefix, local.build_suffix)
  namespace = var.xc_namespace
  app_type_settings {
    app_type_ref {
      name = format("%s-mud-app-%s", local.project_prefix, local.build_suffix)
      namespace = "shared"
    }
    business_logic_markup_setting {
      // One of the arguments from this list "disable enable" must be set
      enable = true
    }
    user_behavior_analysis_setting {
      // One of the arguments from this list "enable_learning disable_learning" must be set
      enable_learning = true
      // One of the arguments from this list "enable_detection disable_detection" must be set
      enable_detection {
        // One of the arguments from this list "cooling_off_period" must be set
        cooling_off_period = "20"
        // One of the arguments from this list "include_failed_login_activity exclude_failed_login_activity" must be set
        include_failed_login_activity {
          login_failures_threshold = "10"
        }
        // One of the arguments from this list "include_forbidden_activity exclude_forbidden_activity" must be set
        include_forbidden_activity {
	  forbidden_requests_threshold = "10"
	}
        // One of the arguments from this list "exclude_ip_reputation include_ip_reputation" must be set
        include_ip_reputation = true
        // One of the arguments from this list "exclude_non_existent_url_activity include_non_existent_url_activity_custom include_non_existent_url_activity_automatic" must be set
        exclude_non_existent_url_activity = true
        // One of the arguments from this list "include_waf_activity exclude_waf_activity" must be set
        include_waf_activity = true
      }
    }
  }
}

resource "volterra_malicious_user_mitigation" "auto-mitigation" {
    count = var.xc_mud ? 1 : 0
    name = format("%s-mud-%s", local.project_prefix, local.build_suffix)
    namespace = var.xc_namespace
    mitigation_type {
        rules {      
            threat_level {
                low = true
            }
            mitigation_action {
                javascript_challenge = true
            }
        }
        rules {
            threat_level {
                medium = true
            }
            mitigation_action {
                captcha_challenge = true
            }
        }
        rules {
            threat_level {
                high = true
            }
            mitigation_action {
                block_temporarily = true
            }
        }
    }
}
