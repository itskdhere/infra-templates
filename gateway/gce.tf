# Google Compute Engine VM
resource "google_compute_instance" "gateway-vm" {
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

  tags = [
    "dns-server",
    # "dhcp-server",
    "dot-server",
    "doh-server",
    "doq-server",
    "dnscrypt-server",
    "beszel",
  ]

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
