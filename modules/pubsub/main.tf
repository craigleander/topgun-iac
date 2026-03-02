# Pub/Sub topics and subscriptions - using Google provider
# Pub/Sub resource names must be lowercase
resource "google_pubsub_topic" "topics" {
  for_each = toset(var.topic_names)
  name     = "${lower(var.prefix)}-${each.value}"
  project  = var.project_id
  labels   = var.labels
}

resource "google_pubsub_subscription" "subs" {
  for_each = { for pair in flatten([
    for topic, subs in var.subscription_names_map : [
      for s in subs : { topic = topic, sub = s }
    ]
  ]) : "${pair.topic}-${pair.sub}" => pair }
  name    = "${lower(var.prefix)}-${each.value.sub}"
  topic   = google_pubsub_topic.topics["${each.value.topic}"].name
  project = var.project_id
  labels  = var.labels
}
