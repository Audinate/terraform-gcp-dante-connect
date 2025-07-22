#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  webrtc_endpoint_instance_network_tags = {
    ssh  = "${var.component_name_abbreviation}-ssh-allow"
    udp  = "${var.component_name_abbreviation}-udp-allow"
    icmp = "${var.component_name_abbreviation}-icmp-allow"
  }
}

resource "google_compute_firewall" "bridge_fw_allow_udp" {
  name    = "fw-${var.component_name_abbreviation}-udp-${var.environment}-${random_id.random.hex}"
  network = var.network_self_link
  project = var.project

  direction     = "INGRESS"
  source_ranges = ["10.0.0.0/8", "172.16.0.0/16", "192.168.0.0/16"]

  target_tags = [local.webrtc_endpoint_instance_network_tags.udp]

  allow {
    protocol = "udp"
    ports    = ["319-320"]
  }

  allow {
    protocol = "udp"
    ports    = ["14336-14591"]
  }

  allow {
    protocol = "udp"
    ports    = ["8700-8899"]
  }

  allow {
    protocol = "udp"
    ports    = ["4440-4455"]
  }

  allow {
    protocol = "udp"
    ports    = ["38700-38900"]
  }
}

resource "random_id" "random" {
  byte_length = 4
}

resource "google_compute_firewall" "bridge_fw_allow_ext_ssh" {
  name    = "fw-${var.component_name_abbreviation}-ssh-${var.environment}-${random_id.random.hex}"
  network = var.network_self_link
  project = var.project

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = [local.webrtc_endpoint_instance_network_tags.ssh]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "bridge_fw_allow_icmp" {
  name    = "fw-${var.component_name_abbreviation}-icmp-${var.environment}-${random_id.random.hex}"
  network = var.network_self_link
  project = var.project

  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]

  target_tags = [local.webrtc_endpoint_instance_network_tags.icmp]

  # allow all ICMP
  allow {
    protocol = "icmp"
  }
}
