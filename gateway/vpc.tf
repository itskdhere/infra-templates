# VPC Firewall Rules
resource "google_compute_firewall" "allow-dns" {
  name    = "allow-dns"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dns-server"]
}

resource "google_compute_firewall" "allow-dhcp" {
  name    = "allow-dhcp"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["68"]
  }

  allow {
    protocol = "udp"
    ports    = ["67", "68"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dhcp-server"]
}

resource "google_compute_firewall" "allow-dot" {
  name    = "allow-dot"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["853"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dot-server"]
}

resource "google_compute_firewall" "allow-doh" {
  name    = "allow-doh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  allow {
    protocol = "udp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["doh-server"]
}

resource "google_compute_firewall" "allow-doq" {
  name    = "allow-doq"
  network = "default"

  allow {
    protocol = "udp"
    ports    = ["784", "853", "8853"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["doq-server"]
}

resource "google_compute_firewall" "allow-dnscrypt" {
  name    = "allow-dnscrypt"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5443"]
  }

  allow {
    protocol = "udp"
    ports    = ["5443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["dnscrypt-server"]
}

resource "google_compute_firewall" "allow-beszel" {
  name    = "allow-beszel"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["45876"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["beszel"]
}
