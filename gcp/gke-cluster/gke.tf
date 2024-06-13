data "google_client_config" "provider" {}

# GKE cluster
resource "google_container_cluster" "genai_gke" {
  name     = "${local.project_prefix}-gke-${local.build_suffix}"
  location = local.region
  
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = local.network_name
  subnetwork = local.subnet_name
  deletion_protection = false
}

# Separately Managed Node Pool
resource "google_container_node_pool" "genai_gke_nodes" {
  name       = google_container_cluster.genai_gke.name
  location   = local.region
  cluster    = google_container_cluster.genai_gke.name
  node_count = var.gke_num_nodes

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = local.project_id
    }

    # preemptible  = true
    machine_type = "e2-standard-4"
    tags         = ["gke-node", "${local.project_prefix}-gke-${local.build_suffix}"]
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
