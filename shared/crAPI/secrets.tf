resource "kubernetes_secret" "jwks-secret" {
    metadata {
        name = "jwt-key-secret"
    }
    
    type = "kubernetes.io/generic"

    data = {
        "jwks.json" = base64encode(var.json_input)
    }
}