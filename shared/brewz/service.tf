resource "kubernetes_service_v1" "mongodb" {
  metadata {
    name = "mongodb"
  }

  spec {
    port {
      port        = 27017
      target_port = 27017
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "mongodb"
    }
  }
}

resource "kubernetes_service_v1" "api" {
  metadata {
    name = "api"
  }

  spec {
    port {
      port        = 8000
      target_port = 8000
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "api"
    }
  }
}

resource "kubernetes_service_v1" "spa" {
  metadata {
    name = "spa"
  }

  spec {
    port {
      port        = 80
      target_port = 80
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "spa"
    }
  }
}

resource "kubernetes_service_v1" "recommendations" {
  metadata {
    name = "recommendations"
  }

  spec {
    port {
      port        = 8001
      target_port = 8001
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "recommendations"
    }
  }
}

resource "kubernetes_service_v1" "inventory" {
  metadata {
    name = "inventory"
  }

  spec {
    port {
      port        = 8002
      target_port = 8002
      protocol    = "TCP"
      name        = "http"
    }

    selector = {
      app = "inventory"
    }
  }
}
