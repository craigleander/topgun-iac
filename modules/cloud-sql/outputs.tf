output "connection_name" {
  value       = google_sql_database_instance.main.connection_name
  description = "Cloud SQL connection name"
}

output "private_ip_address" {
  value       = google_sql_database_instance.main.private_ip_address
  description = "Private IP (when private_network set)"
}

output "public_ip_address" {
  value       = google_sql_database_instance.main.public_ip_address
  description = "Public IP"
}

output "instance_name" {
  value       = google_sql_database_instance.main.name
  description = "Instance name"
}
