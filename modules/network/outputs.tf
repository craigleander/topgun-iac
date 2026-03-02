output "network_id" {
  value       = google_compute_network.main.id
  description = "VPC network ID"
}

output "network_name" {
  value       = google_compute_network.main.name
  description = "VPC network name"
}

output "subnetwork_name" {
  value       = var.use_existing_subnet ? data.google_compute_subnetwork.existing[0].name : google_compute_subnetwork.main[0].name
  description = "Subnet name"
}

output "subnetwork_id" {
  value       = var.use_existing_subnet ? data.google_compute_subnetwork.existing[0].id : google_compute_subnetwork.main[0].id
  description = "Subnet ID"
}

output "service_networking_connection" {
  value       = google_service_networking_connection.private_vpc
  description = "Service networking connection (for Cloud SQL private IP)"
}
