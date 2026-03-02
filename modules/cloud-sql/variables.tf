variable "project_id" {
  type = string
}

variable "name" {
  type = string
}

variable "region" {
  type = string
}

variable "tier" {
  type    = string
  default = "db-f1-micro"
}

variable "disk_size" {
  type    = number
  default = 10
}

variable "private_network" {
  type        = string
  description = "VPC network ID for private IP"
}

variable "db_name" {
  type = string
}

variable "user_name" {
  type = string
}

variable "user_password" {
  type      = string
  sensitive = true
}

variable "labels" {
  type    = map(string)
  default = {}
}
