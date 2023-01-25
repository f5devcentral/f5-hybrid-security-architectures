# Create XC LB config

resource "volterra_origin_pool" "op" {
  name                   = format("%s-xcop-%s", local.project_prefix, local.build_suffix)
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server %s", local.origin_server)
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
  no_tls = true
  port = local.origin_port
  endpoint_selection     = "LOCALPREFERED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "lb_https" {
  name      = format("%s-xclb-%s", local.project_prefix, local.build_suffix)
  namespace = var.xc_namespace
  labels = {
      "ves.io/app_type" = length(var.xc_app_type) != 0 ? volterra_app_type.app-type[0].name : null
  }
  description = format("HTTPS loadbalancer object for %s origin server", local.project_prefix)  
  domains = [var.app_domain]
  advertise_on_public_default_vip = true
  default_route_pools {
      pool {
        name = volterra_origin_pool.op.name
        namespace = var.xc_namespace
      }
      weight = 1
    }
  https_auto_cert {
    add_hsts = false
    http_redirect = true
    no_mtls = true
    enable_path_normalize = true
    tls_config {
        default_security = true
      }
  }
  app_firewall {
    name = volterra_app_firewall.waap-tf.name
    namespace = var.xc_namespace
  }
  disable_waf                     = false
  enable_malicious_user_detection = var.xc_mud ? true : null
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge = contains(var.xc_app_type, "mud") || var.xc_mud ? false : true
  multi_lb_app = var.xc_multi_lb ? true : false
  user_id_client_ip = true
  source_ip_stickiness = true
  dynamic "api_definition" {
    for_each = var.xc_api_def ? [1] : []
    content {
      name = volterra_api_definition.api-def[0].name
      namespace = volterra_api_definition.api-def[0].namespace
    }
  }
  dynamic "enable_api_discovery" {
    for_each = var.xc_api_disc ? [1] : []
    content {
      enable_learn_from_redirect_traffic = true
    } 
  }
  dynamic "policy_based_challenge" {
    for_each = var.xc_mud ? [1] : []
    content {
      default_js_challenge_parameters = true
      default_captcha_challenge_parameters = true
      default_mitigation_settings = true
      no_challenge = true
      rule_list {}
    }
  }
  dynamic "policy_based_challenge" {
    for_each = contains(var.xc_app_type, "mud") && var.xc_multi_lb ? [1] : []
    content {
      malicious_user_mitigation {
        namespace = volterra_malicious_user_mitigation.mud-mitigation[0].namespace
        name = volterra_malicious_user_mitigation.mud-mitigation[0].name
      } 
    }
  }
}


