data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "gcp-infra"
}
data "tfe_outputs" "gke" {
  organization = var.tf_cloud_organization
  workspace = "gke"
}
