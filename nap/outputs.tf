output "load-balancer-hostname" {
  value = data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
}
output "nginx_service" {
    value = format("%s-%s", helm_release.nginx_plus_ingress.name , helm_release.nginx_plus_ingress.chart)
}