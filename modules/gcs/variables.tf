variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "location" {
  type        = string
  description = "Bucket location (region)"
}

variable "prefix" {
  type        = string
  description = "Prefix for bucket names"
}

variable "names" {
  type        = list(string)
  description = "Bucket name suffixes"
}

variable "labels" {
  type        = map(string)
  description = "Labels for buckets"
  default     = {}
}

variable "force_destroy" {
  type        = bool
  description = "Allow destroy to delete bucket even if it has objects (set true for ephemeral/dev)"
  default     = false
}
