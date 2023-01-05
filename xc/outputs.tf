
output "xc_lb_name" {
  value = volterra_http_loadbalancer.lb_https.name
}
output "xc_waf_name" {
  value = volterra_app_firewall.waap-tf.name
}
