output "dev-vm-public-ip" {
  description = "Public IP of the dev VM"
  value       = google_compute_instance.dev-vm.network_interface.0.access_config.0.nat_ip
}

output "dev-vm-dns-name" {
  description = "DNS name of the dev VM"
  value       = cloudflare_dns_record.dev-vm-dns.name
}
