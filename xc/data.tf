data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organzation
  workspace = "infra"
}
data "tfe_outputs" "bigip" {
  organization = var.tf_cloud_organzation
  workspace = "bigip"
}
data "tfe_outputs" "nap" {
  organization = var.tf_cloud_organzation
  workspace = "nap-kic"
}
data "tfe_outputs" "test" {
  organization = var.tf_cloud_organzation
  workspace = "test"
}