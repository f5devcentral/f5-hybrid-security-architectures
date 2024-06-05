data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "${coalesce(var.aws, var.azure, var.gcp, "infra")}"
}
data "tfe_outputs" "gcp-infra" {
  count = var.hybrid_genai ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "gcp-infra"
}
data "tfe_outputs" "bigip" {
  count = data.tfe_outputs.infra.values.bigip ? 1 : 0
  organization = var.tf_cloud_organization
  workspace = "bigip-base"
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
data "tfe_outputs" "eks" {
  count               = var.hybrid_genai ? 1 : 0
  organization        = var.tf_cloud_organization
  workspace           = "eks"
}
data "tfe_outputs" "gke" {
  count               = var.hybrid_genai ? 1 : 0
  organization        = var.tf_cloud_organization
  workspace           = "gke"
}
