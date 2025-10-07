output "gateway-vm-public-ip" {
  description = "Public IP of the gateway VM"
  value       = google_compute_instance.gateway-vm.network_interface.0.access_config.0.nat_ip
}

output "gateway-vm-dns-name" {
  description = "DNS name of the gateway VM"
  value       = cloudflare_dns_record.gateway-vm-dns.name
}
