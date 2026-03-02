output "name" {
  value       = module.cluster.name
  description = "GKE cluster name"
}

output "endpoint" {
  value       = module.cluster.endpoint
  sensitive   = true
  description = "GKE API endpoint"
}

output "ca_certificate" {
  value       = module.cluster.ca_certificate
  sensitive   = true
  description = "Cluster CA certificate (base64)"
}

output "cluster_id" {
  value       = module.cluster.cluster_id
  description = "Cluster ID"
}

output "location" {
  value       = module.cluster.location
  description = "Cluster location (region)"
}
