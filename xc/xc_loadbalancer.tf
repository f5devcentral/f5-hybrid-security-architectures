# Create XC LB config

resource "volterra_origin_pool" "op" {
  name        = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace   = var.xc_namespace
  description = format("Origin pool pointing to origin server %s", local.origin_server)
  dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [1] : []
    content {
      public_name {
        dns_name = local.origin_server
      }
    }
  }
  dynamic "origin_servers" {
    for_each = local.dns_origin_pool ? [] : [1]
    content {
      public_ip {
        ip = local.origin_server
      }
    }
  }
  no_tls                 = true
  port                   = local.origin_port
  endpoint_selection     = "LOCAL_PREFERRED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "lb_https" {
  name      = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace = var.xc_namespace
  labels = {
    "ves.io/app_type" = length(var.xc_app_type) != 0 ? volterra_app_type.app-type[0].name : null
  }
  description                     = format("HTTPS loadbalancer object for %s origin server", local.project_prefix)
  domains                         = [var.app_domain]
  advertise_on_public_default_vip = true
  default_route_pools {
    pool {
      name      = volterra_origin_pool.op.name
      namespace = var.xc_namespace
    }
    weight = 1
  }
  https_auto_cert {
    add_hsts              = false
    http_redirect         = true
    no_mtls               = true
    enable_path_normalize = true
    tls_config {
      default_security = true
    }
  }
  app_firewall {
    name      = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }
  disable_waf                     = false
  round_robin                     = true
  service_policies_from_namespace = true
  multi_lb_app                    = var.xc_multi_lb ? true : false
  user_id_client_ip               = true
  source_ip_stickiness            = true

  #API Protection Configuration

  dynamic "enable_api_discovery" {
    for_each = var.xc_api_disc ? [1] : []
    content {
      enable_learn_from_redirect_traffic = true
      discovered_api_settings {
        purge_duration_for_inactive_discovered_apis = 5
      }
    }
  }
  dynamic "api_specification" {
    for_each = var.xc_api_pro ? [1] : []
    content {
      api_definition {
        name      = volterra_api_definition.api-def[0].name
        namespace = volterra_api_definition.api-def[0].namespace
        tenant    = var.xc_tenant
      }
      validation_disabled = var.xc_api_val ? false : true
      dynamic "validation_all_spec_endpoints" {
        for_each = var.xc_api_val_all ? [1] : []
        content {
          validation_mode {
            dynamic "validation_mode_active" {
              for_each = var.xc_api_val_active ? [1] : []
              content {
                request_validation_properties = var.xc_api_val_properties
                enforcement_block             = var.enforcement_block
                enforcement_report            = var.enforcement_report
              }
            }
            dynamic "response_validation_mode_active" {
              for_each = var.xc_resp_val_active ? [1] : []
              content {
                response_validation_properties = var.xc_resp_val_properties
                enforcement_block              = var.enforcement_block
                enforcement_report             = var.enforcement_report
              }
            }
          }
          fall_through_mode {
            fall_through_mode_allow = var.fall_through_mode_allow ? true : false
            dynamic "fall_through_mode_custom" {
              for_each = var.fall_through_mode_allow ? [0] : [1]
              content {
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-block-%s", local.project_prefix, local.build_suffix)
                  }
                  action_block = true
                  base_path    = "/"
                }
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-report-%s", local.project_prefix, local.build_suffix)
                  }
                  action_report = true
                  base_path     = "/"
                }
              }
            }
          }
          settings {
            oversized_body_fail_validation = true
            property_validation_settings_custom {
              query_parameters {
                disallow_additional_parameters = true
              }
            }
          }
        }
      }
      dynamic "validation_custom_list" {
        for_each = var.xc_api_val_custom ? [1] : []
        content {
          open_api_validation_rules {
            metadata {
              name = format("%s-apip-val-rule-block-%s", local.project_prefix, local.build_suffix)
            }
            validation_mode {
              dynamic "validation_mode_active" {
                for_each = var.xc_api_val_active ? [1] : []
                content {
                  request_validation_properties = var.xc_api_val_properties
                  enforcement_block             = var.enforcement_block
                  enforcement_report            = var.enforcement_report
                }
              }
              dynamic "response_validation_mode_active" {
              for_each = var.xc_resp_val_active ? [1] : []
              content {
                response_validation_properties = var.xc_resp_val_properties
                enforcement_block              = var.enforcement_block
                enforcement_report             = var.enforcement_report
              }
            }
            }
            any_domain = true
            base_path  = "/"
          }
          fall_through_mode {
            fall_through_mode_allow = var.fall_through_mode_allow ? true : false
            dynamic "fall_through_mode_custom" {
              for_each = var.fall_through_mode_allow ? [0] : [1]
              content {
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-block-%s", local.project_prefix, local.build_suffix)
                  }
                  action_block = true
                  base_path    = "/"
                }
                open_api_validation_rules {
                  metadata {
                    name = format("%s-apip-fall-through-report-%s", local.project_prefix, local.build_suffix)
                  }
                  action_report = true
                  base_path     = "/"
                }
              }
            }
          }
          settings {
            oversized_body_fail_validation = true
            property_validation_settings_custom {
              query_parameters {
                disallow_additional_parameters = true
              }
            }
          }
        }
      }
    }
  }

  dynamic "api_protection_rules" {
    for_each = var.xc_api_pro ? [1] : []
    content {
      api_groups_rules {
        metadata {
          name = format("%s-apip-deny-rule-%s", local.project_prefix, local.build_suffix)
        }
        action {
          deny = true
        }
        base_path = "/api"
        api_group = join("-", ["ves-io-api-def", volterra_api_definition.api-def[0].name, "all-operations"])
      }
      api_groups_rules {
        metadata {
          name = format("%s-apip-allow-rule-%s", local.project_prefix, local.build_suffix)
        }
        action {
          deny = false
        }
        base_path = "/"
      }
    }
  }
  dynamic "jwt_validation" {
    for_each = var.xc_jwt_val ? [1] : []
    content {
      target {
        all_endpoint = true
      }
      token_location {
        bearer_token = true
      }
      action {
        block = var.jwt_val_block
        report = var.jwt_val_report
      }
      jwks_config {
        cleartext = "string:///${var.jwks}"
      }
      reserved_claims {
        issuer                  = var.iss_claim
        audience {
          audiences             = var.aud_claim
        }     
        validate_period_enable  = var.exp_claim
      }
    }
  }

  #BOT Configuration
  dynamic "bot_defense" {
    for_each = var.xc_bot_def ? [1] : []
    content {
      policy {
        javascript_mode = "ASYNC_JS_NO_CACHING"
        disable_js_insert = false
        js_insert_all_pages {
          javascript_location = "AFTER_HEAD"
        }
        disable_mobile_sdk = true
        js_download_path   = "/common.js"
        protected_app_endpoints {
          metadata {
            name = format("%s-bot-rule-%s", local.project_prefix, local.build_suffix)
          }
          http_methods = ["METHOD_POST", "METHOD_PUT"]
          mitigation {
            block {
              status = "Unauthorized"
              body   = "string:///WW91ciByZXF1ZXN0IHdhcyBCTE9DS0VEID4uPAo="
            }
          }
          path {
            path = "/trading/login.php"
          }
          flow_label {
            authentication {
              login { }
            }
          }
        }
      }
      regional_endpoint = "US"
      timeout           = 1000
    }
  }

  #DDoS Configuration
  dynamic "enable_ddos_detection" {
    for_each = var.xc_ddos_pro ? [1] : []
    content {
      enable_auto_mitigation {
        block = true
      }
    }
  }
  dynamic "ddos_mitigation_rules" {
    for_each = var.xc_ddos_pro ? [1] : []
    content {
      metadata {
        name = format("%s-ddos-rule-%s", local.project_prefix, local.build_suffix)
      }
      block = true
      ddos_client_source {
        country_list = ["COUNTRY_KP"]
      }
    }
  }

  #Common Security Controls

  disable_rate_limit              = true
  enable_malicious_user_detection = var.xc_mud ? true : null
  no_challenge                    = contains(var.xc_app_type, "mud") || var.xc_mud ? false : true

  dynamic "policy_based_challenge" {
    for_each = var.xc_mud ? [1] : []
    content {
      default_js_challenge_parameters      = true
      default_captcha_challenge_parameters = true
      default_mitigation_settings          = true
      no_challenge                         = true
      rule_list {}
    }
  }
  dynamic "policy_based_challenge" {
    for_each = contains(var.xc_app_type, "mud") && var.xc_multi_lb ? [1] : []
    content {
      malicious_user_mitigation {
        namespace = volterra_malicious_user_mitigation.mud-mitigation[0].namespace
        name      = volterra_malicious_user_mitigation.mud-mitigation[0].name
      }
    }
  }
}


