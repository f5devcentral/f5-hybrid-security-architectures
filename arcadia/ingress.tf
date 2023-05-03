resource "kubernetes_ingress_v1" "arcadia-ingress" {
  metadata {
    name = "arcadia-ingress"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      #host = try(data.tfe_outputs.nap.values.external_name, data.tfe_outputs.nic.values.external_name, "arcadia-cd-demo.sr.f5-cloud-demo.com")
      host = try(data.tfe_outputs.nap[0].values.external_name, data.tfe_outputs.nic[0].values.external_name)
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