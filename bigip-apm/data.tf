data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}
data "tfe_outputs" "bigip-base" {
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
}
data "tfe_outputs" "juiceshop" {
  organization = var.tf_cloud_organization
  workspace = "juiceshop"
}
