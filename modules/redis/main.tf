# Memorystore for Redis - uses Google provider (no separate registry module)
resource "google_redis_instance" "main" {
  name           = var.name
  project        = var.project_id
  memory_size_gb = var.memory_size_gb
  region         = var.region
  tier           = "BASIC"
  redis_version  = "REDIS_7_0"

  authorized_network = var.network
  connect_mode       = "DIRECT_PEERING"

  labels = var.labels
}
