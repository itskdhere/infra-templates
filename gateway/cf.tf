# Cloudflare DNS Record
resource "cloudflare_dns_record" "gateway-vm-dns" {
  depends_on = [google_compute_instance.gateway-vm]
  zone_id    = var.cloudflare_zone_id
  name       = var.dns_name
  content    = google_compute_instance.gateway-vm.network_interface.0.access_config.0.nat_ip
  type       = "A"
  proxied    = false
  ttl        = 60
  comment    = "DNS Record of gateway VM (via Terraform)"
}
