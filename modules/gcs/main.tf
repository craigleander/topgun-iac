# GCS buckets using Google provider (official API)
resource "google_storage_bucket" "buckets" {
  for_each = toset(var.names)

  name     = "${var.prefix}-${each.value}"
  project  = var.project_id
  location = var.location
  labels   = var.labels

  uniform_bucket_level_access = true
  force_destroy               = var.force_destroy
}
