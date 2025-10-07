# Cloudflare DNS Record
resource "cloudflare_dns_record" "dev-vm-dns" {
  depends_on = [google_compute_instance.dev-vm]
  zone_id    = var.cloudflare_zone_id
  name       = var.dns_name
  content    = google_compute_instance.dev-vm.network_interface.0.access_config.0.nat_ip
  type       = "A"
  proxied    = false
  ttl        = 60
  comment    = "DNS Record of dev VM (via Terraform)"
}
