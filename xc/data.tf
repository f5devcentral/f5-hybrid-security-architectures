data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
data "tfe_outputs" "bigip" {
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
}
data "tfe_outputs" "nap" {
  organization = var.tf_cloud_organization
  workspace = "nap"
}
data "tfe_outputs" "nic" {
  organization = var.tf_cloud_organization
  workspace = "nic"
}