provider "google" {
    region     = local.gcp_region
    project    = local.project_id
}


provider "kubectl" {
    host = "https://${local.host}"
    cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
    token = local.cluster_access_token
    load_config_file  = false
}


provider "kubernetes" {
  host                   = "https://${local.host}"
  client_certificate     = base64decode(local.cluster_client_certificate)
  client_key             = base64decode(local.cluster_client_key)
  cluster_ca_certificate = base64decode(local.cluster_ca_certificate)
  token                  = local.cluster_access_token
}