output "kubernetes_cluster_name" {
  value       = nonsensitive(google_container_cluster.genai_gke.name)
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.genai_gke.endpoint
  description = "GKE Cluster Host"
}

output "kubernetes_cluster_client_certificate" {
  value       = google_container_cluster.genai_gke.master_auth.0.client_certificate
  description = "GKE Cluster Client Certificate"
}

output "kubernetes_cluster_client_key" {
  value       = nonsensitive(google_container_cluster.genai_gke.master_auth.0.client_key)
  description = "GKE Cluster Client Key"
}

output "kubernetes_cluster_ca_certificate" {
  value       = google_container_cluster.genai_gke.master_auth.0.cluster_ca_certificate
  description = "GKE Cluster CA Certificate"
}

output "kubernetes_cluster_access_token" {
  value       = nonsensitive(data.google_client_config.provider.access_token)
  description = "GKE Cluster Access Token"
}