data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "eks"
}
data "tfe_outputs" "nap" {
  count = data.tfe_outputs.infra.values.nap ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "nap"
}
data "tfe_outputs" "nic" {
  count = data.tfe_outputs.infra.values.nic ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "nic"
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}
