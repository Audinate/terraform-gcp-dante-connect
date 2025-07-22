#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  associate_public_ip_address = var.associate_public_ephemeral_ip_address || var.associate_public_static_ip_address
}

resource "google_service_account" "default_service_account" {
  count        = var.service_account == null ? 1 : 0
  project      = var.project
  account_id   = var.instance_name
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_address" "static_external_ip" {
  count        = var.associate_public_static_ip_address ? 1 : 0
  name         = "ip-ext-${var.environment}-${random_id.random.hex}"
  region       = var.region
  project      = var.project
  network_tier = var.public_static_ip_network_tier
}

resource "google_compute_address" "static_internal_ip" {
  count        = var.associate_internal_static_ip_address ? 1 : 0
  name         = "ip-int-${var.environment}-${random_id.random.hex}"
  region       = var.region
  project      = var.project
  address_type = "INTERNAL"
  purpose      = "GCE_ENDPOINT"
  subnetwork   = var.subnet_self_link
}

resource "random_id" "random" {
  byte_length = 4
}

resource "google_compute_instance" "vm_instance" {
  name    = var.instance_name
  project = var.project
  zone    = var.zone

  boot_disk {
    initialize_params {
      size  = var.volume_size
      image = var.image
    }
  }

  network_interface {
    subnetwork = var.subnet_self_link
    network_ip = var.associate_internal_static_ip_address ? google_compute_address.static_internal_ip[0].address : null

    dynamic "access_config" {
      for_each = local.associate_public_ip_address ? [1] : []
      content {
        nat_ip       = var.associate_public_static_ip_address ? google_compute_address.static_external_ip[0].address : null
        network_tier = var.instance_network_tier
      }
    }
    nic_type = var.nic_type
  }

  tags                      = var.firewall_tags
  machine_type              = var.machine_type
  metadata                  = var.metadata
  allow_stopping_for_update = true
  enable_display            = var.enable_virtual_displays
  can_ip_forward            = !var.source_dest_check
  resource_policies         = compact([var.placement_policy])

  labels = {
    environment = var.environment
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = var.service_account == null ? google_service_account.default_service_account[0].email : var.service_account
    scopes = ["cloud-platform"]
  }

  dynamic "scheduling" {
    // Include the scheduling block only if the maintenance policy is defined
    for_each = var.maintenance_policy == null ? [] : [1]
    content {
      on_host_maintenance = var.maintenance_policy
    }
  }

  # Ignore new ssh-keys and base AMI changes. We want to determine when to create new instances.
  # Suddenly creating a new instance might be very disturbing.
  lifecycle {
    ignore_changes = [
      boot_disk[0].initialize_params[0].image,
      metadata["ssh-keys"]
    ]
  }
}
