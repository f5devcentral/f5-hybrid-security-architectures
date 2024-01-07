resource "kubernetes_ingress_v1" "crapi-ingress" {
  metadata {
    name = "crapi-ingress"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = try(data.tfe_outputs.nap[0].values.external_name, data.tfe_outputs.nic[0].values.external_name)
      http {
        path {
          path = "/"
          backend {
            service {
                name = kubernetes_service_v1.crapi_web_service.metadata[0].name
                port {
                    number = 80
                }
            }
          }
        }
        path {
          path = "/mailhog"
          backend {
            service {
                name = kubernetes_service_v1.mailhog_web_service.metadata[0].name
                port {
                    number = 8025
                }
            }
          }
        }
      }
    }
  }
}