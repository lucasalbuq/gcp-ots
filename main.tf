# Enables the Cloud Run API
resource "google_project_service" "run_api" {
  service = var.api_services

  disable_on_destroy = true
}

# Create the Cloud Run service
resource "google_cloud_run_service" "run_service" {
  name     = var.service_name
  location = var.location

  metadata {
    namespace = var.project_id
  }

  template {
    spec {
      containers {
        image = var.container_name
        ports {
          container_port = var.container_port
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  # Waits for the Cloud Run API to be enabled
  depends_on = [google_project_service.run_api]
}

# Domain mapping
resource "google_cloud_run_domain_mapping" "default" {
  location = var.location
  name     = var.domain_mapped_name

  metadata {
    namespace = var.project_id
  }

  spec {
    route_name     = google_cloud_run_service.run_service.name
    force_override = true
  }
}

# Allow unauthenticated users to invoke the service
resource "google_cloud_run_service_iam_member" "run_all_users" {
  service  = google_cloud_run_service.run_service.name
  location = google_cloud_run_service.run_service.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}


# Display the service URL
output "service_url" {
  value = google_cloud_run_service.run_service.status[0].url
}

output "cname_url" {
  value = "https://${var.domain_mapped_name}"
}
