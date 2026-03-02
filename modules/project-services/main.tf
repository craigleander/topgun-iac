# Enable GCP APIs (non-authoritative: adds services, does not disable others not in the list).
locals {
  services = var.enable_apis ? toset(var.activate_apis) : toset([])
}

resource "google_project_service" "project_services" {
  for_each                   = local.services
  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}
