data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "eks"
}
data "tfe_outputs" "bigip-base" {
  count = data.tfe_outputs.infra.values.bigip ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
}
data "tfe_outputs" "bigip-cis" {
  count = data.tfe_outputs.infra.values.bigip-cis ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "bigip-cis"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
data "kubernetes_service_v1" "nginx-service" {
  metadata {
    name = try(format("%s-%s-controller", helm_release.nginx-plus-ingress.0.name, helm_release.nginx-plus-ingress.0.chart), format("%s-%s", helm_release.nginx-plus-ingresslink.0.name, helm_release.nginx-plus-ingresslink.0.chart))
    namespace = try(helm_release.nginx-plus-ingress[0].namespace, helm_release.nginx-plus-ingresslink[0].namespace)
  }
}
/*
data "kubernetes_service_v1" "nginx-service-link" {
  count = local.bigip_cis ? 1 : 0
  metadata {
    name = format("%s-%s", helm_release.nginx-plus-ingresslink[0].name, helm_release.nginx-plus-ingresslink[0].chart)
    namespace = helm_release.nginx-plus-ingresslink[0].namespace
  }
}
*/
