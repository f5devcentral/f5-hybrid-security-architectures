resource "kubernetes_config_map_v1" "mailhog_configmap" {
  metadata {
    name = "mailhog-configmap"
    labels = {
      app = "mailhog"
    }
  }
  data = {
    MH_MONGO_URI = "admin:crapisecretpassword@mongodb:27017"
    MH_STORAGE   = "mongodb"
  }
}

resource "kubernetes_deployment_v1" "mailhog_deployment" {
  metadata {
    name      = "mailhog"
    namespace = "crapi"
  }
  spec {
    selector {
      match_labels = {
        app = "mailhog"
      }
    }
    replicas              = 1
    min_ready_seconds     = 10
    progress_deadline_seconds = 600
    template {
      metadata {
        labels = {
          app = "mailhog"
        }
        annotations = {
          "sidecar.traceable.ai/inject" = "false"
        }
      }
      spec {
        security_context {
          run_as_user  = 0
          run_as_group = 0
        }
        container {
          name  = "mailhog"
          image = "crapi/mailhog:latest"
          image_pull_policy = "Always"
          liveness_probe {
            tcp_socket {
              port = 1025
            }
            initial_delay_seconds = 15
            period_seconds        = 60
          }
          readiness_probe {
            tcp_socket {
              port = 1025
            }
            initial_delay_seconds = 15
            period_seconds        = 20
          }
          port {
            container_port = 8025
            name           = "web"
            protocol       = "TCP"
          }
          port {
            container_port = 1025
            name           = "smtp"
            protocol       = "TCP"
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.mailhog_configmap.metadata[0].name
            }
          }
          resources {
            limits = {
              cpu    = "1"
              memory = "1024Mi"
            }
            requests = {
              cpu    = "50m"
              memory = "64Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mailhog_web_service" {
  metadata {
    name      = "mailhog-web"
    namespace = "crapi"
  }

  spec {
    selector = {
      app = "mailhog"
    }
    port {
      name       = "web"
      port        = 30025
      target_port = 30025
      protocol    = "TCP"
    }
    session_affinity = "None"
    type            = "CluserIP"
  }
}

resource "kubernetes_service_v1" "mailhog_service" {
  metadata {
    name      = "mailhog"
    namespace = "crapi"
  }
  spec {
    selector = {
      app = "mailhog"
    }
    port {
      name        = "smtp"
      port        = 1025
      target_port = 1025
      protocol    = "TCP"
    }
    session_affinity = "None"
    type            = "ClusterIP"
  }
}
