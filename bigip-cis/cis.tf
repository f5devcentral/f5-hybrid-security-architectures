module "postbuild-config-cis" {
  source  = "f5devcentral/postbuild-config/bigip//as3"
  version = "0.6.3"
  bigip_user       = var.f5_username
  bigip_password   = local.bigip_password
  bigip_address    = local.bigip_address
  bigip_as3_payload = templatefile(var.cis_config_payload,
  {
  bigip_k8s_partition = var.bigip_k8s_partition
  }
  )
}
module "postbuild-config-cis-irule" {
  source  = "f5devcentral/postbuild-config/bigip//as3"
  version = "0.6.3"
  bigip_user       = var.f5_username
  bigip_password   = local.bigip_password
  bigip_address    = local.bigip_address
  bigip_as3_payload = file(var.irule_config_payload)
}

resource "kubernetes_deployment_v1" "cis-deployment" {
  metadata {
    name = "k8s-bigip-ctlr-deployment"
    namespace = "kube-system"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "k8s-bigip-ctlr-deployment"
      }
    }
    template {
      metadata {
        labels = {
          app = "k8s-bigip-ctlr-deployment"
        }
      }
      spec {
        container {
          name = "k8s-bigip-ctlr"
          image = "f5networks/k8s-bigip-ctlr:2.7.1"
          env {
            name = "BIGIP_USERNAME"
            value_from {
              secret_key_ref {
                name = "bigip-login"
                key = "username"
              }
            }
          }
          env {
            name = "BIGIP_PASSWORD"
            value_from {
              secret_key_ref {
                name = "bigip-login"
                key = "password"
             }
           }
          }
          command = [ "/app/bin/k8s-bigip-ctlr" ]
          args = [ "--bigip-username=$(BIGIP_USERNAME)", "--bigip-password=$(BIGIP_PASSWORD)", "--bigip-url=https://${local.bigip_mgmt}", "--bigip-partition=${var.bigip_k8s_partition}", "--pool-member-type=cluster", "--namespace=nginx-ingress", "--custom-resource-mode=true", "--insecure", "--log-as3-response=true", "--log-level=DEBUG", ]
        }
        service_account_name = kubernetes_service_account_v1.bigip-ctlr.metadata[0].name
      }
    }
  }
}
