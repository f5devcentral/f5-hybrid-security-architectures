resource "kubernetes_deployment" "fdxri_tomcat" {
  metadata {
    name = "fdxri_tomcat"
    labels = {
      app = "fdxri_tomcat"
    }
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "fdxri_tomcat"
      }
    }
    template {
      metadata {
        labels = {
          app = "fdxri_tomcat"
        }
      }
      spec {
        container {
          name  = "fdxri_tomcat"
          image = "docker-registry.financialdataexchange.org/fdxri_dc_tomcat:latest"

          port {
            container_port = 8080
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service" "tomcat" {
  metadata {
    name = "tomcat"
    labels = {
      app = "fdxri_tomcat"
      service = "tomcat"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 8080
      target_port = "8080"
    }
    selector = {
      app = "fdxri_tomcat"
    }
    type = "ClusterIP"
  }
}

resource "kubernetes_deployment" "postgres_container" {
  metadata {
    name = "postgres_container"
    labels = {
      app = "postgres_container"
    }
  }
  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "postgres_container"
      }
    }
    template {
      metadata {
        labels = {
          app = "postgres_container"
        }
      }
      spec {
        container {
          name  = "postgres_container"
          image = "docker-registry.financialdataexchange.org/fdxri_pgdb:latest"
          port {
            container_port = 5432
          }
          image_pull_policy = "IfNotPresent"
        }
      }
    }
  }
}

resource "kubernetes_service" "postgres" {
  metadata {
    name = "postgres"
    labels = {
      app = "postgres_container"
      service = "postgres"
    }
  }
  spec {
    port {
      protocol    = "TCP"
      port        = 5432
      target_port = "5432"
    }
    selector = {
      app = "postgres_container"
    }
    type = "ClusterIP"
  }
}
