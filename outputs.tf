output "gke_cluster_name" {
  value       = module.gke.name
  description = "GKE cluster name"
}

output "gke_endpoint" {
  value       = module.gke.endpoint
  sensitive   = true
  description = "GKE API endpoint"
}

output "gcs_bucket_names" {
  value       = module.gcs.names_list
  description = "GCS bucket names"
}

output "redis_host" {
  value       = module.redis.host
  description = "Redis host (for GKE apps in same VPC)"
}

output "redis_port" {
  value       = module.redis.port
  description = "Redis port"
}

output "cloud_sql_connection_name" {
  value       = module.cloud_sql.connection_name
  description = "Cloud SQL connection name (for Cloud SQL Auth Proxy)"
}

output "cloud_sql_private_ip" {
  value       = module.cloud_sql.private_ip_address
  description = "Cloud SQL private IP (in VPC)"
}

output "pubsub_topic_names" {
  value       = module.pubsub.topic_names
  description = "Pub/Sub topic names"
}

