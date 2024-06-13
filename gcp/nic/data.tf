data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "gcp-infra"
}

data "tfe_outputs" "gke" {
  organization = var.tf_cloud_organization
  workspace = "gke"
}

data "kubernetes_service" "service_ingress" {
  metadata {
    name      = "nginx-ingress"
    namespace = "nginx-ingress"
  }
  depends_on = [null_resource.lb-wait]
}


