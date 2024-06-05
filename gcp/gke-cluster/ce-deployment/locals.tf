locals {
  project_id = data.tfe_outputs.infra.values.project_id
  project_prefix = data.tfe_outputs.infra.values.project_prefix
  host = data.tfe_outputs.gke.values.kubernetes_cluster_host
  gcp_region = data.tfe_outputs.infra.values.region
  cluster_ca_certificate = data.tfe_outputs.gke.values.kubernetes_cluster_ca_certificate
  cluster_name = data.tfe_outputs.gke.values.kubernetes_cluster_name
  cluster_access_token = data.tfe_outputs.gke.values.kubernetes_cluster_access_token
  cluster_client_certificate = data.tfe_outputs.gke.values.kubernetes_cluster_client_certificate
  cluster_client_key = data.tfe_outputs.gke.values.kubernetes_cluster_client_key
}