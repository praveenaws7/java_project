provider "google" {
  credentials = file("/c/Users/QC/Downloads/credentials.json")
  project = "330224828591"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_instance" "gcp-ec2" {

  name         = "fedramp-2"
  machine_type = "n1-standard-1"

  boot_disk {
    initialize_params {
      image = "ubuntu-minimal-2410-oracular-arm64-v20241021"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
}

resource "google_compute_firewall" "example_firewall" {
  name    = "praveen-firewall"
  network = "default" # Replace with your network name if different

  # Ingress (inbound) rule to allow ports 22, 80, and 8080
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"] # Replace with a specific CIDR block if needed

  # Egress (outbound) rule to allow all ports (optional)
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }


}
