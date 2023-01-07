data "tfe_outputs" "infra" {
  organization = "knowbase"
  workspace = "infra"
}
data "tfe_outputs" "eks" {
  organization = "knowbase"
  workspace = "eks"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
data "kubernetes_service_v1" "nginx-service" {
  metadata {
    name = format("%s-%s", helm_release.nginx-plus-ingress.name, helm_release.nginx-plus-ingress.chart)
    namespace = helm_release.nginx-plus-ingress.namespace
  }
}