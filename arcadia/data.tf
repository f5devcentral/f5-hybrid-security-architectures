data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "infra"
}
data "tfe_outputs" "eks" {
  organization = "knowbase"
  workspace = "eks"
}
data "tfe_outputs" "nap" {
  organization = "knowbase"
  workspace = "nap-kic"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
/*
data "kubernetes_service_v1" "nginx-service" {
  metadata {
    name = format("%s-%s",local.project_prefix, "nginx-ingress")
    namespace = "nginx-ingress"
  }
}
*/