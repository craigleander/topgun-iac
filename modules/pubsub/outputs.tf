output "topic_names" {
  value       = [for t in google_pubsub_topic.topics : t.name]
  description = "Pub/Sub topic names"
}

output "topic_ids" {
  value       = { for k, t in google_pubsub_topic.topics : k => t.id }
  description = "Pub/Sub topic IDs"
}

output "subscription_names" {
  value       = [for s in google_pubsub_subscription.subs : s.name]
  description = "Pub/Sub subscription names"
}
