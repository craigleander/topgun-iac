variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "name" {
  type        = string
  description = "Redis instance name"
}

variable "memory_size_gb" {
  type        = number
  description = "Memory size in GB"
  default     = 1
}

variable "network" {
  type        = string
  description = "VPC network ID for the Redis instance"
}

variable "labels" {
  type        = map(string)
  description = "Labels"
  default     = {}
}
