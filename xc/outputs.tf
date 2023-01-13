
output "xc_lb_name" {
  value = nonsensitive(volterra_http_loadbalancer.lb_https.name)
}
output "xc_waf_name" {
  value = nonsensitive(volterra_app_firewall.waap-tf.name)
}
output "endpoint" {
  value = var.app_domain
}