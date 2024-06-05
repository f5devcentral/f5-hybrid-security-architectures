# Create a random id
resource "random_id" "build_suffix" {
  byte_length = 2
}


# VPC creation
resource "google_compute_network" "vpc_network" {
        name = "${var.project_prefix}-vpc-${random_id.build_suffix.hex}"
        auto_create_subnetworks = false
}

# Creating subnetwork
resource "google_compute_subnetwork" "subnet" {
        name = "${var.project_prefix}-subnet-${random_id.build_suffix.hex}"
        ip_cidr_range = var.cidr
        region = var.region
        network = google_compute_network.vpc_network.name
}

# Router Nat
resource "google_compute_router" "router" {
  name    = "${var.project_prefix}-router-${random_id.build_suffix.hex}"
  region  = google_compute_subnetwork.subnet.region
  network = google_compute_network.vpc_network.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.project_prefix}-nat-${random_id.build_suffix.hex}"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

# firewall rules
resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_firewall" "http" {
  name    = "allow-http"
  network = google_compute_network.vpc_network.id
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}