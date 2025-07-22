#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  dvs_instance_network_tags = {
    ssh  = "${var.component_name_abbreviation}-ssh-allow"
    dvs  = "${var.component_name_abbreviation}-udp-allow"
    http = "${var.component_name_abbreviation}-http-allow"
    icmp = "${var.component_name_abbreviation}-icmp-allow"
    rdp  = "${var.component_name_abbreviation}-rdp-allow"
  }
}

resource "random_id" "random" {
  byte_length = 4
}

resource "google_compute_firewall" "dvs_fw_allow_udp" {
  name    = "fw-dvs-udp-${var.environment}-${random_id.random.hex}"
  project = var.project

  network = var.network_self_link
  allow {
    protocol = "udp"
    ports    = ["14336-14591"]
  }

  allow {
    protocol = "udp"
    ports    = ["319-320"]
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
  target_tags   = [local.dvs_instance_network_tags.dvs]
}

resource "google_compute_firewall" "dvs_fw_allow_ssh" {
  name    = "fw-dvs-ssh-${var.environment}-${random_id.random.hex}"
  project = var.project
  network = var.network_self_link
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.dvs_instance_network_tags.ssh]
}

resource "google_compute_firewall" "dvs_fw_allow_icmp" {
  name    = "fw-dvs-icmp-${var.environment}-${random_id.random.hex}"
  project = var.project
  network = var.network_self_link
  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.dvs_instance_network_tags.icmp]
}

resource "google_compute_firewall" "dvs_fw_allow_rdp" {
  name    = "fw-dvs-rdp-${var.environment}-${random_id.random.hex}"
  project = var.project
  network = var.network_self_link
  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = [local.dvs_instance_network_tags.rdp]
}
