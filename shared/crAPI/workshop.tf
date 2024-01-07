resource "kubernetes_config_map_v1" "crapi_workshop_configmap" {
  metadata {
    name = "crapi-workshop-configmap"
    labels = {
      app = "crapi-workshop"
    }
  }

  data = {
    IDENTITY_SERVICE      = "crapi-identity:8080"
    SECRET_KEY            = "crapi"
    DB_HOST               = "postgresdb"
    DB_DRIVER             = "postgres"
    DB_USER               = "admin"
    DB_PASSWORD           = "crapisecretpassword"
    DB_NAME               = "crapi"
    DB_PORT               = "5432"
    MONGO_DB_HOST         = "mongodb"
    MONGO_DB_DRIVER       = "mongodb"
    MONGO_DB_PORT         = "27017"
    MONGO_DB_USER         = "admin"
    MONGO_DB_PASSWORD     = "crapisecretpassword"
    MONGO_DB_NAME         = "crapi"
    SERVER_PORT           = "8000"
  }
}

resource "kubernetes_deployment_v1" "crapi_workshop_deployment" {
  metadata {
    name = "crapi-workshop"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "crapi-workshop"
      }
    }
    template {
      metadata {
        labels = {
          app = "crapi-workshop"
        }
      }
      spec {
        init_container {
          name  = "wait-for-crapi-identity"
          image = "groundnuty/k8s-wait-for:v1.3"

          image_pull_policy = "Always"

          args = ["service", "crapi-identity"]
        }
        init_container {
          name  = "wait-for-crapi-community"
          image = "groundnuty/k8s-wait-for:v1.3"

          image_pull_policy = "Always"

          args = ["service", "crapi-community"]
        }
        container {
          name  = "crapi-workshop"
          image = "crapi/crapi-workshop:latest"
          image_pull_policy = "Always"
          port {
            container_port = 8000
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.crapi_workshop_configmap.metadata[0].name
            }
          }
          resources {
            limits = {
              cpu = "256m"
            }
            requests = {
              cpu = "256m"
            }
          }
          readiness_probe {
            tcp_socket {
              port = 8000
            }
            initial_delay_seconds = 15
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "crapi_workshop_service" {
  metadata {
    name = "crapi-workshop"
    labels = {
      app = "crapi-workshop"
    }
  }
  spec {
    selector = {
      app = "crapi-workshop"
    }
    port {
      port = 8000
      name = "python"
    }
  }
}
