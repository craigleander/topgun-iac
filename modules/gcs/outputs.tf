output "names_list" {
  value       = [for b in google_storage_bucket.buckets : b.name]
  description = "List of bucket names"
}

output "buckets" {
  value       = google_storage_bucket.buckets
  description = "Bucket resources"
}
