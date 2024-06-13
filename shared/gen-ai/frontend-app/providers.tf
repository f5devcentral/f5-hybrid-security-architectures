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