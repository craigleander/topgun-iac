variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "prefix" {
  type        = string
  description = "Prefix for topic and subscription names"
}

variable "topic_names" {
  type        = list(string)
  description = "Topic names (without prefix)"
}

variable "subscription_names_map" {
  type        = map(list(string))
  description = "Map of topic name to list of subscription names"
  default     = {}
}

variable "labels" {
  type        = map(string)
  description = "Labels"
  default     = {}
}
