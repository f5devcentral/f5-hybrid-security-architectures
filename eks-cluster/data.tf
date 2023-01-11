data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "infra"
}

