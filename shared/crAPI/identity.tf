resource "kubernetes_config_map_v1" "crapi_identity_configmap" {
  metadata {
    name = "crapi-identity-configmap"
    labels = {
      app = "crapi-identity"
    }
  }
  data = {
    DB_HOST                  = "postgresdb"
    DB_DRIVER                = "postgresql"
    JWT_SECRET               = "crapi" # Used for creating a JWT. Can be anything
    DB_USER                  = "admin"
    DB_PASSWORD              = "crapisecretpassword"
    DB_NAME                  = "crapi"
    DB_PORT                  = "5432"
    APP_NAME                 = "crapi-identity"
    ENABLE_SHELL_INJECTION   = "false"
    ENABLE_LOG4J             = "true"
    MAILHOG_HOST             = "mailhog"
    MAILHOG_PORT             = "1025"
    MAILHOG_DOMAIN           = "example.com"
    SMTP_HOST                = "smtp.example.com"
    SMTP_PORT                = "587"
    SMTP_EMAIL               = "user@example.com"
    SMTP_PASS                = "xxxxxxxxxxxxxx"
    SMTP_FROM                = "no-reply@example.com"
    SMTP_AUTH                = "true"
    JWT_EXPIRATION           = "604800000"
    SMTP_STARTTLS            = "true"
    SERVER_PORT              = "8080"
  }
}


resource "kubernetes_deployment_v1" "crapi_identity" {
  metadata {
    name = "crapi-identity"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "crapi-identity"
      }
    }
    template {
      metadata {
        labels = {
          app = "crapi-identity"
        }
      }
      spec {
        init_container {
          name  = "wait-for-postgres"
          image = "groundnuty/k8s-wait-for:v1.3"

          args = ["service", "postgresdb"]

          image_pull_policy = "Always"
        }
        volume {
          name = "jwt-key-secret"

          secret {
            secret_name = "jwt-key-secret"
          }
        }
        container {
          name  = "crapi-identity"
          image = "crapi/crapi-identity:latest"
          volume_mount {
            mount_path  = "/.keys"
            name        = "jwt-key-secret"
            read_only   = true
          }
          image_pull_policy = "Always"
          port {
            container_port = 8080
          }
          env_from {
            config_map_ref {
              name = "crapi-identity-configmap"
            }
          }
          resources {
            limits = {
              cpu = "500m"
            }
            requests = {
              cpu = "256m"
            }
          }
          readiness_probe {
            tcp_socket {
              port = 8080
            }
            initial_delay_seconds = 15
            period_seconds        = 10
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "crapi_identity" {
  metadata {
    name = "crapi-identity"
    labels = {
      app = "crapi-identity"
    }
  }
  spec {
    selector = {
      app = "crapi-identity"
    }
    port {
      port        = 8080
      target_port = 8080
      name        = "java"
    }
  }
}