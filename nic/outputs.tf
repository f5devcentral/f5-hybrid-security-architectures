output "external_name" {
    value = try(data.kubernetes_service_v1.nginx-service[0].status.0.load_balancer.0.ingress.0.hostname, data.kubernetes_service_v1.nginx-service-link[0].status.0.load_balancer.0.ingress.0.hostname, "")
}
output "external_port" {
    value = try(data.kubernetes_service_v1.nginx-service[0].spec.0.port.0.port, data.kubernetes_service_v1.nginx-service-link[0].spec.0.port.0.port, "")
}
output "origin_source" {
    value = "nic"
}
output "nic_deployment_name" {
    value = try (helm_release.nginx-plus-ingress[0].name, helm_release.nginx-plus-ingresslink[0].name)
    sensitive = true
}