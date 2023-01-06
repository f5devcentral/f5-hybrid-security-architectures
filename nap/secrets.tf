resource "kubernetes_secret" "docker-registry" {
    metadata {
        name = "docker-registry"
        namespace = kubernetes_namespace.nginx-ingress.metadata[0].name
    }
    
    type = "kubernetes.io/dockerconfigjson"

    data = {
        ".dockerconfigjson" = jsonencode({
            auths = {
                "${var.nginx_registry}" = {
                    "username" = var.nginx_jwt
                    #"password" = var.registry_password
                }
            }
        })
    }
}