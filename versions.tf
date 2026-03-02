terraform {
  required_version = ">= 1.3.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.25.0, < 6.0.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  credentials = file(var.gcp_credentials_path)
}

# Kubernetes provider: only used if you add k8s resources; host must be a valid URL so use a placeholder until cluster exists
provider "kubernetes" {
  host                   = coalesce(module.gke.endpoint, "https://placeholder.invalid")
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = try(base64decode(module.gke.ca_certificate), "")
}

data "google_client_config" "default" {}
