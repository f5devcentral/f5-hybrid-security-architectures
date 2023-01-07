resource "kubernetes_ingress" "arcadia" {
  wait_for_load_balancer = true
  metadata {
    name = "arcadia"
    annotations = {
      "kubernetes.io/ingress.class" = "nginx"
    }
  }
  spec {
    rule {
      http {
        path {
          path = "/"
          backend {
            service_name = kubernetes_service.main.metadata.0.name
            service_port = 80
          }
        }
        path {
          path = "/files"
          backend {
            service_name = kubernetes_service.backend.metadata.0.name
            service_port = 80
          }
        }
        path {
          path = "/api"
          backend {
            service_name = kubernetes_service.app_2.metadata.0.name
            service_port = 80
          }
        }
        path {
          path = "/app3"
          backend {
            service_name = kubernetes_service.app_3.metadata.0.name
            service_port = 80
          }
        }
      }
    }
  }
}