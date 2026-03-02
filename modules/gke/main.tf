# GKE cluster using official Terraform registry module
module "cluster" {
  source  = "terraform-google-modules/kubernetes-engine/google"
  version = "~> 31.0"

  project_id        = var.project_id
  name              = "${var.name_prefix}-gke"
  region            = var.region
  regional          = true
  zones             = var.zones
  network           = var.network_name
  subnetwork        = var.subnetwork_name
  ip_range_pods     = "pods"
  ip_range_services = "services"

  release_channel     = "REGULAR"
  gateway_api_channel = "CHANNEL_STANDARD"

  deletion_protection = var.deletion_protection

  create_service_account = false
  service_account        = var.node_service_account_email

  # Create cluster without built-in default pool so our node_pools are the only ones (avoids "already exists" on first apply)
  remove_default_node_pool = true
  initial_node_count       = 1

  node_pools = var.node_pools

  node_pools_labels = var.node_pools_labels
  node_pools_tags   = var.node_pools_tags
}
