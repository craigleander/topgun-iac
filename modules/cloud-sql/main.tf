# Cloud SQL PostgreSQL 16 - using Google provider (official API)
resource "google_sql_database_instance" "main" {
  project             = var.project_id
  name                = var.name
  database_version     = "POSTGRES_16"
  region              = var.region
  deletion_protection  = false

  settings {
    tier              = var.tier
    availability_type = "ZONAL"
    disk_size         = var.disk_size
    disk_type         = "PD_SSD"
    disk_autoresize   = true

    database_flags {
      name  = "max_connections"
      value = "100"
    }

    ip_configuration {
      ipv4_enabled    = true
      private_network = var.private_network
    }

    backup_configuration {
      enabled                        = true
      start_time                     = "03:00"
      point_in_time_recovery_enabled = false
    }

    user_labels = var.labels
  }
}

resource "google_sql_database" "db" {
  name     = var.db_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
  charset  = "UTF8"
}

resource "google_sql_user" "user" {
  name     = var.user_name
  instance = google_sql_database_instance.main.name
  project  = var.project_id
  password = var.user_password
}
