resource "kubernetes_ingress_v1" "fdx-ingress" {
  wait_for_load_balancer = true
  metadata {
    name = "fdx-ingress"
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      host = try(data.tfe_outputs.nap.values.external_name, data.tfe_outputs.nic.values.external_name)
      http {
        path {
          path = "/"
          backend {
            service {
                name = kubernetes_service.fdxri_tomcat.metadata.0.name
                port {
                    number = 8080
                }
            }
          }
        }
      }
    }
  }
}
