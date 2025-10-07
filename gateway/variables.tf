# Google Cloud Platform
variable "credentials_path" {
  type      = string
  sensitive = true
}
# -- or --
variable "access_token" {
  type      = string
  sensitive = true
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "us-central1"
}

variable "zone" {
  type    = string
  default = "us-central1-c"
}

variable "vm_name" {
  type    = string
  default = "gateway"
}

variable "vm_type" {
  type    = string
  default = "e2-micro"
}

variable "disk_size" {
  type    = number
  default = 30
}

variable "disk_image" {
  type    = string
  default = "projects/debian-cloud/global/images/debian-12-bookworm-v20250910"
}

variable "service_account_scopes" {
  type    = list(string)
  default = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
}

variable "service_account_email" {
  type      = string
  sensitive = true
}

variable "ssh_username" {
  type      = string
  sensitive = true
}

variable "ssh_public_key_path" {
  type      = string
  sensitive = true
}

variable "ssh_private_key_path" {
  type      = string
  sensitive = true
}

# Cloudflare
variable "cloudflare_api_token" {
  type      = string
  sensitive = true
}

variable "cloudflare_zone_id" {
  type      = string
  sensitive = true
}

variable "dns_name" {
  type = string
}

# Tailscale
# variable "tailscale_auth_key" {
#   type = string
# }

variable "tailscale_api_token" {
  type      = string
  sensitive = true
}

variable "tailscale_network" {
  type      = string
  sensitive = true
}
