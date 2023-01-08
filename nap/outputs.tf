output "external_name" {
    value = data.kubernetes_service_v1.nginx-service.status.0.load_balancer.0.ingress.0.hostname
} 
output "origin_source" {
    value = "nap"
}