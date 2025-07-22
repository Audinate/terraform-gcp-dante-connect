#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  dgw_instance_network_tags = {
    ssh  = "${var.component_name_abbreviation}-ssh-allow"
    udp  = "${var.component_name_abbreviation}-udp-allow"
    icmp = "${var.component_name_abbreviation}-icmp-allow"
  }
}

resource "random_id" "random" {
  byte_length = 4
}

resource "google_compute_firewall" "dgw_fw_allow_udp" {
  name    = "fw-dgw-udp-${var.environment}-${random_id.random.hex}"
  project = var.project

  network = var.network_self_link
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

  source_ranges = ["172.16.0.0/12", "192.168.0.0/16", "10.0.0.0/8"]
  target_tags   = [local.dgw_instance_network_tags.udp]
}

resource "google_compute_firewall" "dgw_fw_allow_ssh" {
  name    = "fw-dgw-ssh-${var.environment}-${random_id.random.hex}"
  project = var.project
  network = var.network_self_link

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.dgw_instance_network_tags.ssh]
}

resource "google_compute_firewall" "dgw_fw_allow_icmp" {
  name      = "fw-dgw-icmp-${var.environment}-${random_id.random.hex}"
  project   = var.project
  network   = var.network_self_link
  direction = "INGRESS"
  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.dgw_instance_network_tags.icmp]
}
