terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.25.0"
    }
  }
}

provider "google" {
  # credentials = file(var.credentials_path)
  access_token = var.access_token
  project      = var.project_id
  region       = var.region
}
