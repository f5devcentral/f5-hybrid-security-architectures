resource "kubernetes_config_map_v1" "crapi-community-configmap" {
    metadata {
        name = "crapi-community-configmap"
        labels = {
            app = "crapi-community"
        }
    }
    data = {
        IDENTITY_SERVICE = "crapi-identity:8080"
        DB_HOST = "postgresdb"
        DB_DRIVER = "postgres"
        DB_USER = "admin"
        DB_PASSWORD = "crapisecretpassword"
        DB_NAME = "crapi"
        DB_PORT = "5432"
        MONGO_DB_HOST = "mongodb"
        MONGO_DB_DRIVER = "mongodb"
        MONGO_DB_USER = "admin"
        MONGO_DB_PASSWORD = "crapisecretpassword"
        MONGO_DB_NAME = "crapi"
        MONGO_DB_PORT = "27017"
        SERVER_PORT = "8087"   
    } 
}

resource "kubernetes_deployment_v1" "crapi-community-deployment" {
    metadata {
      name = "crapi-community"
    }
    spec {
      replicas = 1
      selector {
          match_labels = {
          app = "crapi-community"
          }
        }
      template {
          metadata {
            labels = {
              app = "crapi-community"
            }
          }
          spec {
            init_container {
              name = "wait-for-postgres"
              image = "groundnuty/k8s-wait-for:v1.3"
              image_pull_policy = Allways
              args = ["service", "postgresdb"]
            }
            init_container {
              name = "wait-for-mongo"
              image = "groundnuty/k8s-wait-for:v1.3"
              image_pull_policy = Allways
              args = ["service", "mongodb"]
            }
            init_container {
              name = "wait-for-java"
              image = "groundnuty/k8s-wait-for:v1.3"
              image_pull_policy = Allways
              args = ["service", "crapi-identity"]
            }
            container {
              name = "crapi-community"
              image = "groundnuty/crapi-community:latest"
              image_pull_policy = Allways
              port {
                container_port = 8087
              }
              env_from {
                config_map_ref {
                  name = "crapi-community-configmap"
                }
              }
              resources {
                limits = {
                  cpu = "500m"
                }
                requests = {
                  cpu = "500m"
                }
              }
            }
          }
        }
    } 
}

resource "kubernetes_service_v1" "crapi-community-service" {
    metadata {
      name = "crapi-community"
      labels = {
        app = "crapi-community"
      }
    }
    spec {
      selector = {
        app = "crapi-community"
      }
      port {
        port = 8087
        name = "go"
      }
    }
}