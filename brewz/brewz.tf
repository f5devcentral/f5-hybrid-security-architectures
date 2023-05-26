# Mongo
resource "kubernetes_deployment_v1" "mongodb" {
  metadata {
    name = "mongodb"
  }

  spec {
    replicas = 1

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
          image = "mongo"

          port {
            container_port = 27017
          }

          volume_mount {
            name      = "mongo-initdb"
            mount_path = "/docker-entrypoint-initdb.d"
          }
        }

        volume {
          name = "mongo-initdb"

          config_map {
            name = "mongo-initdb"
          }
        }
      }
    }
  }
}

# API

resource "kubernetes_deployment_v1" "api" {
  metadata {
    name = "api"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app = "api"
        }
      }

      spec {
        container {
          name  = "api"
          image = "ghcr.io/f5devcentral/spa-demo-app-api:sha-eb52ccf"

          port {
            container_port = 8000
          }

          env {
            name  = "MONGO_URL"
            value = "mongodb"
          }

          env {
            name  = "INVENTORY_URL"
            value = "http://inventory:8002"
          }

          env {
            name  = "RECOMMENDATIONS_URL"
            value = "http://recommendations:8001"
          }
        }
      }
    }
  }
}

# SPA

resource "kubernetes_deployment_v1" "spa" {
  metadata {
    name = "spa"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "spa"
      }
    }

    template {
      metadata {
        labels = {
          app = "spa"
        }
      }

      spec {
        container {
          name  = "spa"
          image = "ghcr.io/f5devcentral/spa-demo-app-spa:sha-eb52ccf"

          port {
            container_port = 80
          }
        }
      }
    }
  }
}

# Recommendations

resource "kubernetes_deployment_v1" "recommendations" {
  metadata {
    name = "recommendations"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "recommendations"
      }
    }

    template {
      metadata {
        labels = {
          app = "recommendations"
        }
      }

      spec {
        container {
          name  = "recommendations"
          image = "ghcr.io/f5devcentral/spa-demo-app-recommendations:sha-eb52ccf"

          port {
            container_port = 8001
          }
        }
      }
    }
  }
}

# Inventory

resource "kubernetes_deployment_v1" "inventory" {
  metadata {
    name = "inventory"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "inventory"
      }
    }

    template {
      metadata {
        labels = {
          app = "inventory"
        }
      }

      spec {
        container {
          name  = "inventory"
          image = "ghcr.io/f5devcentral/spa-demo-app-inventory:sha-eb52ccf"

          port {
            container_port = 8002
          }
        }
      }
    }
  }
}
