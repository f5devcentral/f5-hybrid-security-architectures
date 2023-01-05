# ---------------------------------------------------------------------------- #
# Create XC LB config
# ---------------------------------------------------------------------------- #

resource "volterra_origin_pool" "op_dns" {
  count = var.dns_origin_pool == true ? 1 : 0
  name                   = "${local.project_prefix}-xcop-${local.build_suffix}"
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server %s", var.origin_server_dns_name)
  origin_servers {
    public_name {
      dns_name = var.origin_server_dns_name
    }
    labels = {
    }
  }
  no_tls = false
  port = "443"
  endpoint_selection     = "LOCALPREFERED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_origin_pool" "op_ip" {
  count = var.dns_origin_pool == false ? 1 : 0
  name                   = "${local.project_prefix}-xcop-${local.build_suffix}"
  namespace              = var.xc_namespace
  description            = format("Origin pool pointing to origin server %s", local.origin_server_ip_address)
  origin_servers {
    public_ip {
      ip = var.origin_server_ip_address
    }
    labels = {
    }
  }
  no_tls = false
  port = "443"
  endpoint_selection     = "LOCALPREFERED"
  loadbalancer_algorithm = "LB_OVERRIDE"
}

resource "volterra_http_loadbalancer" "lb_https" {
  name      = "${local.project_prefix}-xclb-https-${local.build_suffix}"
  namespace = var.xc_namespace
  description = format("HTTPS loadbalancer object for %s origin server", local.project_prefix)  
  domains = [var.app_domain]
  advertise_on_public_default_vip = true
  default_route_pools {
      pool {
        name = var.dns_origin_pool == true ? volterra_origin_pool.op_dns[0].name : volterra_origin_pool.op_ip[0].name
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
    name = "${local.project_prefix}-xcw-${local.build_suffix}"
    namespace = var.xc_namespace
  }
  disable_waf                     = false
  disable_rate_limit              = true
  round_robin                     = true
  service_policies_from_namespace = true
  no_challenge = true
  user_id_client_ip = true
  source_ip_stickiness = true
}


