terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
    }
  }
}

provider "google" {
  impersonate_service_account = var.sa_email
  project                     = var.project_id
  region                      = var.region
  zone                        = var.zone
}
