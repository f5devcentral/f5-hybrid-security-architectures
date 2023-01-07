resource "kubernetes_ingress_v1" "arcadia-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "arcadia-ingress"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = data.tfe_outputs.nap.values.external_name
      http {
        path {
          path = "/"
          backend {
            service {
                name = kubernetes_service.main.metadata.0.name
                port {
                    number = 80
                }
            }
          }
        }
        path {
          path = "/files"
          backend {
            service {
                name = kubernetes_service.backend.metadata.0.name
                port {
                    number = 80
                }
            }
          }
        }
        path {
          path = "/api"
          backend {
            service {
                name = kubernetes_service.app_2.metadata.0.name
                port {
                    number = 80
                }
            }
          }
        }
        path {
          path = "/app3"
          backend {
            service {
                name = kubernetes_service.app_3.metadata.0.name
                port {
                    number = 80
                }
            }
          }
        }
      }
    }
  }
}