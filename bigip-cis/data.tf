data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
data "tfe_outputs" "bigip-base" {
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
}
data "tfe_outputs" "eks" {
  organization = var.tf_cloud_organization
  workspace = "eks"
}
data "aws_instance" "bigip" {
  instance_id = data.tfe_outputs.bigip-base.values.f5vm01_instance_ids
  filter {
    name = "tag:Owner"
    values = [local.resource_owner]
  }
}
data "aws_eks_cluster_auth" "auth" {
  name = data.tfe_outputs.eks.values.cluster_name
}