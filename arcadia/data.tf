data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "onewaap-infra"
}
data "tfe_outputs" "eks" {
  organization = "knowbase"
  workspace = "xc-nap-eks"
}
data "tfe_outputs" "nap" {
  organization = "knowbase"
  workspace = "xc-nap-kic"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
data "kubernetes_service" "nginx-service" {
  metadata {
    name = data.tfe_outputs.nap.values.nginx_service
  }
}