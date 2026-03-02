variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for cluster name (lowercase)"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "zones" {
  type        = list(string)
  description = "List of zones for the regional cluster"
}

variable "network_name" {
  type        = string
  description = "VPC network name"
}

variable "subnetwork_name" {
  type        = string
  description = "Subnetwork name"
}

variable "node_service_account_email" {
  type        = string
  description = "Service account email for GKE nodes"
}

variable "node_pools" {
  type        = list(any)
  description = "Node pool configuration"
}

variable "node_pools_labels" {
  type        = map(map(string))
  description = "Labels per node pool"
}

variable "node_pools_tags" {
  type        = map(list(string))
  description = "Network tags per node pool"
}

variable "deletion_protection" {
  type        = bool
  description = "Enable deletion protection on the GKE cluster (set false to allow destroy)"
  default     = false
}
