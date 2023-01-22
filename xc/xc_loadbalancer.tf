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
  enable_malicious_user_detection = var.xc_mud
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge = true
  user_id_client_ip = true
  source_ip_stickiness = true
    dynamic "policy_based_challenge" {
      for_each = var.xc_mud_custom ? [] : [1]
      content {
        default_js_challenge_parameters = true
        default_captcha_challenge_parameters = true
        default_mitigation_settings = true
        no_challenge = true
        rule_list {}
      }
    }
    dynamic "policy_based_challenge" {
      for_each = var.xc_mud_custom ? [1] : []
      content {
        malicious_user_mitigation {
          namespace = var.xc_namespace
          name = volterra_malicious_user_mitigation.auto-mitigation.name
        } 
      }
    }
}


