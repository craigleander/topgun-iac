variable "project_id" {
  type        = string
  description = "GCP project ID"
}

variable "region" {
  type        = string
  description = "GCP region"
}

variable "name_prefix" {
  type        = string
  description = "Prefix for resource names (lowercase)"
}

variable "subnet_cidr" {
  type        = string
  default     = "10.0.0.0/20"
  description = "Subnet primary CIDR"
}

variable "pods_cidr" {
  type        = string
  default     = "10.4.0.0/14"
  description = "Secondary CIDR for GKE pods"
}

variable "services_cidr" {
  type        = string
  default     = "10.8.0.0/20"
  description = "Secondary CIDR for GKE services"
}

variable "use_existing_subnet" {
  type        = bool
  default     = false
  description = "If true, use data source for existing subnetwork instead of creating"
}
