resource "kubernetes_config_map_v1" "postgres_configmap" {
  metadata {
    name = "postgres-config"
    labels = {
      app = "postgresdb"
    }
  }
  data = {
    POSTGRES_USER     = "admin"
    POSTGRES_PASSWORD = "crapisecretpassword"
    POSTGRES_DB       = "crapi"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "postgres_pv_claim" {
  metadata {
    name = "postgres-pv-claim"
    labels = {
      app = "postgresdb"
    }
  }
  spec {
    # Uncomment the following line if using a specific storageClassName
    # storage_class_name = "local-path"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1000Mi"
      }
    }
  }
}

resource "kubernetes_stateful_set_v1" "postgres_stateful_set" {
  metadata {
    name = "postgresdb"
  }
  spec {
    service_name = "postgresdb"
    replicas     = 1
    selector {
      match_labels = {
        app = "postgresdb"
      }
    }

    template {
      metadata {
        labels = {
          app = "postgresdb"
        }
      }
      spec {
        container {
          name  = "postgres"
          image = "postgres:14"
          image_pull_policy = "IfNotPresent"
          port {
            container_port = 5432
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.postgres_configmap.metadata[0].name
            }
          }
          volume_mount {
            mount_path = "/var/lib/postgresql/data"
            name       = "postgres-data"
            sub_path   = "postgres"
          }
        }

        volume {
          name = "postgres-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.postgres_pv_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "postgres_service" {
  metadata {
    name = "postgresdb"
    labels = {
      app = "postgresdb"
    }
  }
  spec {
    selector = {
      app = "postgresdb"
    }
    port {
      name = "postgres"
      port = 5432
    }
  }
}
