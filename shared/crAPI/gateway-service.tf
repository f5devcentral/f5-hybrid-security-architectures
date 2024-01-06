resource "kubernetes_config_map_v1" "crapi-gateway-configmap" {
  metadata {
    name = "gateway-service-configmap"
    labels = {
      app = "gateway-service"
    }
  }
  data = {
    SERVER_PORT = "443"
  }
}

resource "kubernetes_deployment_v1" "crapi-gateway-deployment" {
    metadata {
      name = "gateway-service"
    }
    spec {
        replicas = 1
        selector {
            match_labels = {
            app = "gateway-service"
            }
        }
        template {
            metadata {
                labels = {
                app = "gateway-service"
                }
            }
            spec {
                container {
                name = "gateway-service"
                image = "crapi/crapi-service:latest"
                image_pull_policy = Allways
                   port {
                       container_port = 8087
                   }
                   resources {
                       limits = {
                       cpu = "100m"
                       }
                       requests = {
                       cpu = "50m"
                       }
                   }
                }
            }
        }
    }
}

resource "kubernetes_service_v1" "crapi-gateway-service" {
    metadata {
      name = "gateway-service"
      labels = {
        app = "gateway-service"
      }
    }
    spec {
      selector = {
        app = "gateway-service"
      }
      port {
        port = 443
        target_port = 8087
      }
    }
}
