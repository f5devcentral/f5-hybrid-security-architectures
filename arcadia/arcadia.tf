resource "kubernetes_deployment" "main" {
  metadata {
    name = "main"
    labels = {
      app = "main"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "main"
      }
    }
    template {
      metadata {
        labels = {
          app = "main"
        }
      }
      spec {
        container {
          name  = "main"
          image = "registry.gitlab.com/arcadia-application/main-app/mainapp:latest"

          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "backend" {
  metadata {
    name = "backend"
    labels = {
      app = "backend"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "backend"
      }
    }
    template {
      metadata {
        labels = {
          app = "backend"
        }
      }
      spec {
        container {
          name  = "backend"
          image = "registry.gitlab.com/arcadia-application/back-end/backend:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "app_2" {
  metadata {
    name = "app2"
    labels = {
      app = "app2"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app2"
      }
    }
    template {
      metadata {
        labels = {
          app = "app2"
        }
      }
      spec {
        container {
          name  = "app2"
          image = "registry.gitlab.com/arcadia-application/app2/app2:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
resource "kubernetes_deployment" "app_3" {
  metadata {
    name = "app3"
    labels = {
      app = "app3"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "app3"
      }
    }

    template {
      metadata {
        labels = {
          app = "app3"
        }
      }

      spec {
        container {
          name  = "app3"
          image = "registry.gitlab.com/arcadia-application/app3/app3:latest"
          port {
            container_port = 80
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}
