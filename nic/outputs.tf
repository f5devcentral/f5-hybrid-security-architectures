output "external_name" {
    value = data.kubernetes_service.nginx-service.status.0.load_balancer.0.ingress.0.hostname
}
output "external_port" {
    value = data.kubernetes_service_v1.nginx-service.spec.0.port.0.port
}
output "origin_source" {
    value = "nic"
}
