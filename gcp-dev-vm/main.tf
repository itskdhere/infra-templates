# Google Compute Engine VM
resource "google_compute_instance" "dev-vm" {
  name         = var.vm_name
  zone         = var.zone
  machine_type = var.vm_type

  boot_disk {
    device_name = var.vm_name
    auto_delete = true
    mode        = "READ_WRITE"
    initialize_params {
      image = var.disk_image
      size  = var.disk_size
      type  = "pd-standard"
    }
  }

  network_interface {
    access_config {
      network_tier = "STANDARD"
    }
    queue_count = 0
    stack_type  = "IPV4_ONLY"
    subnetwork  = "projects/${var.project_id}/regions/${var.region}/subnetworks/default"
  }

  can_ip_forward      = true
  deletion_protection = false
  enable_display      = false

  tags = ["http-server", "https-server"]

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = true
    enable_vtpm                 = true
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  metadata = {
    ssh-keys = "${var.ssh_username}:${file(var.ssh_public_key_path)}"
  }

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  allow_stopping_for_update = true
}

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

# Tailscale Non-Interactive Machine Auth Key Retrieval
resource "tailscale_tailnet_key" "dev-vm-tailscale-key" {
  depends_on    = [google_compute_instance.dev-vm]
  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 1200
  description   = "Tailscale Auth Key for dev VM"
}

# VM Setup with NVM, Node.js, Docker, Tailscale
resource "null_resource" "dev-vm-setup" {
  depends_on = [google_compute_instance.dev-vm, tailscale_tailnet_key.dev-vm-tailscale-key]

  triggers = {
    instance_id = google_compute_instance.dev-vm.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = file(var.ssh_private_key_path)
    host        = google_compute_instance.dev-vm.network_interface.0.access_config.0.nat_ip
  }

  provisioner "file" {
    when        = create
    on_failure  = continue
    source      = "scripts/setup.sh"
    destination = "/tmp/setup.sh"
  }

  provisioner "remote-exec" {
    when       = create
    on_failure = continue
    inline = [
      "chmod +x /tmp/setup.sh",
      "/tmp/setup.sh"
    ]
  }

  provisioner "remote-exec" {
    when       = create
    on_failure = continue
    inline = [
      "sudo tailscale up --auth-key=${tailscale_tailnet_key.dev-vm-tailscale-key.key}",
      "sudo tailscale set --ssh --advertise-exit-node"
    ]
  }
}
