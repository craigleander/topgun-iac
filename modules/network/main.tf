# VPC for GKE, Redis, and Cloud SQL (same network for connectivity)
resource "google_compute_network" "main" {
  name                    = "${var.name_prefix}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = "GLOBAL"
}

data "google_compute_subnetwork" "existing" {
  count       = var.use_existing_subnet ? 1 : 0
  name        = "${var.name_prefix}-subnet"
  region      = var.region
  project     = var.project_id
}

resource "google_compute_subnetwork" "main" {
  count          = var.use_existing_subnet ? 0 : 1
  name           = "${var.name_prefix}-subnet"
  project        = var.project_id
  region         = var.region
  network        = google_compute_network.main.id
  ip_cidr_range  = var.subnet_cidr
  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = var.pods_cidr
  }
  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = var.services_cidr
  }
}

resource "google_compute_global_address" "private_ip_range" {
  name          = "${var.name_prefix}-private-ip"
  project       = var.project_id
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.main.id
}

# GCP cannot delete this connection while Cloud SQL or Redis still use it. For a clean
# destroy, run scripts/destroy.sh (targets cloud_sql and redis first) or remove from
# state and destroy again: terraform state rm 'module.network.google_service_networking_connection.private_vpc'
resource "google_service_networking_connection" "private_vpc" {
  network                 = google_compute_network.main.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_range.name]
}
