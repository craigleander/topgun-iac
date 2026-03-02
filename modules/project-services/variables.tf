variable "project_id" {
  description = "The GCP project to enable APIs on."
  type        = string
}

variable "enable_apis" {
  description = "Whether to enable the APIs. If false, this module is a no-op."
  type        = bool
  default     = true
}

variable "activate_apis" {
  description = "List of API service names to enable (e.g. compute.googleapis.com)."
  type        = list(string)
  default     = []
}

variable "disable_services_on_destroy" {
  description = "Whether to disable project services when the resources are destroyed."
  type        = bool
  default     = false
}

variable "disable_dependent_services" {
  description = "Whether dependent services should also be disabled when a service is destroyed."
  type        = bool
  default     = false
}
