resource "kubernetes_namespace" "nginx-ingress" {
  metadata {
    name = "nginx-ingress"
  }
}
resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}