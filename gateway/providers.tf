terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "5.11.0"
    }
    tailscale = {
      source  = "tailscale/tailscale"
      version = "0.22.0"
    }
  }
}

provider "google" {
  # use "credentials" or "access_token"
  credentials = file(var.credentials_path)
  # access_token = var.access_token

  project = var.project_id
  region  = var.region
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

provider "tailscale" {
  api_key = var.tailscale_api_token
  tailnet = var.tailscale_network
}
