resource "kubernetes_config_map_v1" "crapi_web_configmap" {
  metadata {
    name = "crapi-web-configmap"
    labels = {
      app = "crapi-web"
    }
  }
  data = {
    COMMUNITY_SERVICE = "crapi-community:8087"
    IDENTITY_SERVICE  = "crapi-identity:8080"
    WORKSHOP_SERVICE  = "crapi-workshop:8000"
  }
}

resource "kubernetes_deployment_v1" "crapi_web_deployment" {
  metadata {
    name = "crapi-web"
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "crapi-web"
      }
    }
    template {
      metadata {
        labels = {
          app = "crapi-web"
        }
      }
      spec {
        container {
          name  = "crapi-web"
          image = "crapi/crapi-web:latest"
          image_pull_policy = "Always"
          port {
            container_port = 80
          }
          resources {
            limits = {
              cpu = "500m"
            }
            requests = {
              cpu = "256m"
            }
          }
          env_from {
            config_map_ref {
              name = kubernetes_config_map_v1.crapi_web_configmap.metadata[0].name
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "crapi_web_service" {
  metadata {
    name = "crapi-web"
    labels = {
      app = "crapi-web"
    }
  }
  spec {
      selector = {
      app = "crapi-web"
    }
    port {
      port       = 30080
      node_port  = 30080
      name       = "nginx"
    }
    type = "ClusterIP"
  }
}
