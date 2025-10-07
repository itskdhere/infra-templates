# Tailscale Non-Interactive Machine Auth Key Retrieval
resource "tailscale_tailnet_key" "gateway-vm-tailscale-key" {
  depends_on    = [google_compute_instance.gateway-vm]
  reusable      = false
  ephemeral     = false
  preauthorized = true
  expiry        = 1200
  description   = "Tailscale Auth Key for gateway VM"
}

# VM Setup with Tailscale, Docker etc.
resource "null_resource" "gateway-vm-setup" {
  depends_on = [google_compute_instance.gateway-vm, tailscale_tailnet_key.gateway-vm-tailscale-key]

  triggers = {
    instance_id = google_compute_instance.gateway-vm.id
  }

  connection {
    type        = "ssh"
    user        = var.ssh_username
    private_key = file(var.ssh_private_key_path)
    host        = google_compute_instance.gateway-vm.network_interface.0.access_config.0.nat_ip
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
      "sudo tailscale up --auth-key=${tailscale_tailnet_key.gateway-vm-tailscale-key.key}",
      "sudo tailscale set --ssh --advertise-exit-node"
    ]
  }
}
