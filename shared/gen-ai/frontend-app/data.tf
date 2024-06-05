
data "tfe_outputs" "infra" {
  organization = var.tf_cloud_organization
  workspace = "gcp-infra"
}

data "tfe_outputs" "gke" {
  organization = var.tf_cloud_organization
  workspace = "gke"
}

#data "gke_cluster_auth" "auth" {
#  name = data.tfe_outputs.gke.values.kubernetes_cluster_name
#}
