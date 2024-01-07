resource "kubernetes_config_map_v1" "mongodb_configmap" {
  metadata {
    name = "mongodb-config"
    labels = {
      app = "mongodb"
    }
  }
  data = {
    MONGO_INITDB_ROOT_USERNAME = "admin"
    MONGO_INITDB_ROOT_PASSWORD = "crapisecretpassword"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "mongodb_pv_claim" {
  metadata {
    name = "mongodb-pv-claim"
    labels = {
      app = "mongo"
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

resource "kubernetes_stateful_set_v1" "mongodb_stateful_set" {
  metadata {
    name = "mongodb"
  }
  spec {
    service_name = "mongodb"
    replicas     = 1

    selector {
      match_labels = {
        app = "mongodb"
      }
    }
    template {
      metadata {
        labels = {
          app = "mongodb"
        }
      }
      spec {
        container {
          name  = "mongodb"
          image = "mongo:4.4"

          image_pull_policy = "IfNotPresent"

          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.mongodb_configmap.metadata[0].name
            }
          }
          volume_mount {
            mount_path = "/data/db"
            name       = "mongodb-data"
          }
        }
        volume {
          name = "mongodb-data"

          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.mongodb_pv_claim.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "mongodb_service" {
  metadata {
    name = "mongodb"
    labels = {
      app = "mongodb"
    }
  }
  spec {
    port {
      name       = "mongo"
      port       = 27017
    }
    selector = {
      app = "mongodb"
    }
  }
}
