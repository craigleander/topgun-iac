output "host" {
  value       = google_redis_instance.main.host
  description = "Redis host IP"
}

output "port" {
  value       = google_redis_instance.main.port
  description = "Redis port"
}

output "id" {
  value       = google_redis_instance.main.id
  description = "Redis instance ID"
}
