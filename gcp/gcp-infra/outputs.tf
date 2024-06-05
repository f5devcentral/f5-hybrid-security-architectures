output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "vpc_name" {
  value       = google_compute_network.vpc_network.name
  description = "Gcloud VPC/Network Name"
}

output "subnet_name" {
  value       = google_compute_subnetwork.subnet.name
  description = "GCloud Subnetwork Name"
}

output "project_prefix" {
  value = var.project_prefix
}

output "build_suffix" {
  value = random_id.build_suffix.hex
}