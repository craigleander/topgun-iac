# ------------------------------------------------------------------------------
# Global / environment-agnostic variables (avoid duplicates; override via tfvars)
# ------------------------------------------------------------------------------

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region (enforced Mumbai asia-south1)"
  type        = string
  default     = "asia-south1"
}

variable "zone" {
  description = "GCP zone for zonal resources (e.g. Redis, Cloud SQL)"
  type        = string
  default     = "asia-south1-a"
}

variable "app_name" {
  description = "Application name used as prefix and tag (e.g. TAP)"
  type        = string
  default     = "TAP"
}

variable "environment" {
  description = "Environment (dev, qa, prod)"
  type        = string
}

variable "gcp_credentials_path" {
  description = "Path to GCP service account JSON key file"
  type        = string
}

variable "terraform_sa_email" {
  description = "Email of the identity running Terraform (e.g. client_email from key JSON). Granted roles/iam.serviceAccountUser on the GKE node SA so cluster create can succeed."
  type        = string
}

variable "use_existing_subnet" {
  description = "Use existing subnetwork (data source) instead of creating; set true if subnet already exists from a previous partial apply"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Network (VPC / subnet CIDRs - passed to network module)
# ------------------------------------------------------------------------------
variable "subnet_cidr" {
  description = "Primary subnet CIDR for the VPC"
  type        = string
  default     = "10.0.0.0/20"
}

variable "pods_cidr" {
  description = "Secondary CIDR for GKE pods"
  type        = string
  default     = "10.4.0.0/14"
}

variable "services_cidr" {
  description = "Secondary CIDR for GKE services"
  type        = string
  default     = "10.8.0.0/20"
}

# ------------------------------------------------------------------------------
# GKE
# ------------------------------------------------------------------------------
variable "gke_zones" {
  description = "List of zones for the GKE regional cluster (e.g. [\"asia-south1-a\", \"asia-south1-b\", \"asia-south1-c\"])"
  type        = list(string)
  default     = []
}

variable "gke_node_count" {
  description = "Number of nodes per zone in the GKE default node pool"
  type        = number
  default     = 2
}

variable "gke_machine_type" {
  description = "Machine type for GKE nodes"
  type        = string
  default     = "e2-medium"
}

variable "gke_deletion_protection" {
  description = "Enable GKE cluster deletion protection (set false to allow terraform destroy)"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# GCS
# ------------------------------------------------------------------------------
variable "gcs_bucket_names" {
  description = "List of GCS bucket names (will be prefixed with app_name)"
  type        = list(string)
  default     = ["tap-data", "tap-uploads"]
}

variable "gcs_force_destroy" {
  description = "Allow Terraform destroy to delete GCS buckets even if they contain objects"
  type        = bool
  default     = false
}

# ------------------------------------------------------------------------------
# Cloud SQL (PostgreSQL 16)
# ------------------------------------------------------------------------------
variable "cloud_sql_tier" {
  description = "Cloud SQL instance tier"
  type        = string
  default     = "db-f1-micro"
}

variable "cloud_sql_db_name" {
  description = "Cloud SQL database name"
  type        = string
  default     = "tapdb"
}

variable "cloud_sql_user_name" {
  description = "Cloud SQL user name"
  type        = string
  default     = "tapuser"
}

variable "cloud_sql_user_password" {
  description = "Cloud SQL user password"
  type        = string
  sensitive   = true
}

# ------------------------------------------------------------------------------
# Redis (Memorystore)
# ------------------------------------------------------------------------------
variable "redis_memory_size_gb" {
  description = "Memory size in GB for Redis instance"
  type        = number
  default     = 1
}

# ------------------------------------------------------------------------------
# Pub/Sub
# ------------------------------------------------------------------------------
variable "pubsub_topic_names" {
  description = "List of Pub/Sub topic names (prefixed with app_name)"
  type        = list(string)
  default     = ["tap-events"]
}

variable "pubsub_subscription_names" {
  description = "Map of topic name to subscription name(s) for Pub/Sub"
  type        = map(list(string))
  default     = { "tap-events" = ["tap-events-sub"] }
}

