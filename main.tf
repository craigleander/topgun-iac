# ------------------------------------------------------------------------------
# Resource names: lowercase per GCP; app_name (TAP) in labels/tags
# ------------------------------------------------------------------------------
locals {
  name_prefix = lower("${var.app_name}-${var.environment}")
}

# ------------------------------------------------------------------------------
# Enable required GCP APIs (non-authoritative: adds services, does not disable others)
# Local module: modules/project-services
# ------------------------------------------------------------------------------
module "project_services" {
  source = "./modules/project-services"

  project_id    = var.project_id
  activate_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "redis.googleapis.com",
    "sqladmin.googleapis.com",
    "storage.googleapis.com",
    "storage-api.googleapis.com",
    "pubsub.googleapis.com",
    "iam.googleapis.com",
    "iamcredentials.googleapis.com",
    "servicenetworking.googleapis.com",
    "cloudbuild.googleapis.com",
    "artifactregistry.googleapis.com",
  ]

  disable_services_on_destroy = false
  disable_dependent_services  = false
}

# ------------------------------------------------------------------------------
# Network (VPC, subnet, private IP for Cloud SQL) - module
# ------------------------------------------------------------------------------
module "network" {
  source = "./modules/network"

  project_id          = var.project_id
  region              = var.region
  name_prefix         = local.name_prefix
  use_existing_subnet = var.use_existing_subnet
  subnet_cidr         = var.subnet_cidr
  pods_cidr           = var.pods_cidr
  services_cidr       = var.services_cidr

  depends_on = [module.project_services]
}

# ------------------------------------------------------------------------------
# GCS buckets (local module)
# ------------------------------------------------------------------------------
module "gcs" {
  source = "./modules/gcs"

  project_id    = var.project_id
  location      = var.region
  prefix        = lower(var.app_name)
  names         = var.gcs_bucket_names
  force_destroy = var.gcs_force_destroy
  labels = {
    app       = lower(var.app_name)
    env       = var.environment
    managed-by = "stackgen"
  }
}

# ------------------------------------------------------------------------------
# Redis (Memorystore) - provider resources in wrapper module
# ------------------------------------------------------------------------------
module "redis" {
  source     = "./modules/redis"
  project_id = var.project_id
  region     = var.region
  name       = "${local.name_prefix}-redis"
  memory_size_gb = var.redis_memory_size_gb
  network    = module.network.network_id
  labels = {
    app       = lower(var.app_name)
    env       = var.environment
    managed-by = "stackgen"
  }
}

# ------------------------------------------------------------------------------
# Cloud SQL PostgreSQL 16 (local module using provider)
# ------------------------------------------------------------------------------
module "cloud_sql" {
  source = "./modules/cloud-sql"

  project_id      = var.project_id
  name            = "${local.name_prefix}-sql"
  region          = var.region
  tier            = var.cloud_sql_tier
  disk_size       = 10
  private_network = module.network.network_id
  db_name         = var.cloud_sql_db_name
  user_name       = var.cloud_sql_user_name
  user_password   = var.cloud_sql_user_password
  labels = {
    app       = lower(var.app_name)
    env       = var.environment
    managed-by = "stackgen"
  }

  depends_on = [module.network]
}

# ------------------------------------------------------------------------------
# Pub/Sub (wrapper module using provider)
# ------------------------------------------------------------------------------
module "pubsub" {
  source     = "./modules/pubsub"
  project_id = var.project_id
  prefix     = lower(var.app_name)
  topic_names            = var.pubsub_topic_names
  subscription_names_map = var.pubsub_subscription_names
  labels = {
    app       = lower(var.app_name)
    env       = var.environment
    managed-by = "stackgen"
  }
}

# ------------------------------------------------------------------------------
# GKE node pool service account (created before GKE module; used by nodes + IAM)
# ------------------------------------------------------------------------------
resource "google_service_account" "gke_nodes" {
  project      = var.project_id
  account_id   = "${local.name_prefix}-gke-sa"
  display_name = "GKE nodes SA for ${var.app_name}"
}

# Grant Terraform identity permission to use the GKE node SA (required for GKE cluster create)
resource "google_service_account_iam_member" "terraform_sa_use_gke_sa" {
  service_account_id = google_service_account.gke_nodes.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${var.terraform_sa_email}"
}

# ------------------------------------------------------------------------------
# GKE cluster - module (uses registry under the hood)
# ------------------------------------------------------------------------------
module "gke" {
  source = "./modules/gke"

  project_id                 = var.project_id
  name_prefix                = local.name_prefix
  region                     = var.region
  zones                      = length(var.gke_zones) > 0 ? var.gke_zones : ["${var.region}-a", "${var.region}-b", "${var.region}-c"]
  network_name               = module.network.network_name
  subnetwork_name            = module.network.subnetwork_name
  node_service_account_email = google_service_account.gke_nodes.email
  deletion_protection = var.gke_deletion_protection

  depends_on = [google_service_account.gke_nodes, google_service_account_iam_member.terraform_sa_use_gke_sa]

  node_pools = [
    {
      name               = "default-pool"
      machine_type       = var.gke_machine_type
      node_count         = var.gke_node_count
      min_count          = 1
      max_count          = 5
      local_ssd_count    = 0
      disk_size_gb       = 50
      disk_type          = "pd-standard"
      image_type         = "COS_CONTAINERD"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = false
    }
  ]

  node_pools_labels = {
    all = {
      app       = lower(var.app_name)
      env       = var.environment
      managed-by = "stackgen"
    }
  }

  node_pools_tags = {
    all = [lower(var.app_name), var.environment]
  }
}

resource "google_project_iam_member" "gke_sa_log_writer" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_sa_metric_writer" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow GKE nodes to access GCS buckets (use var so for_each keys are known at plan time)
resource "google_storage_bucket_iam_member" "gke_sa_gcs" {
  for_each = toset([for n in var.gcs_bucket_names : "${lower(var.app_name)}-${n}"])
  bucket   = each.value
  role     = "roles/storage.objectAdmin"
  member   = "serviceAccount:${google_service_account.gke_nodes.email}"
  depends_on = [module.gcs]
}

# Allow GKE nodes to use Cloud SQL Client (for private IP or Auth Proxy)
resource "google_project_iam_member" "gke_sa_cloudsql_client" {
  project = var.project_id
  role    = "roles/cloudsql.client"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow GKE nodes to publish/subscribe to Pub/Sub
resource "google_project_iam_member" "gke_sa_pubsub_publisher" {
  project = var.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_project_iam_member" "gke_sa_pubsub_subscriber" {
  project = var.project_id
  role    = "roles/pubsub.subscriber"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow GKE nodes to list topics/subscriptions (e.g. for validation)
resource "google_project_iam_member" "gke_sa_pubsub_viewer" {
  project = var.project_id
  role    = "roles/pubsub.viewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

# Allow GKE nodes to pull images from GCR (artifact storage)
resource "google_project_iam_member" "gke_sa_gcr_pull" {
  project = var.project_id
  role    = "roles/storage.objectViewer"
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

