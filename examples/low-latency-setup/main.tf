#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
  dvs_firewall_tags = (var.dvs_firewall_tags != null) ? var.dvs_firewall_tags : module.dvs_fw_rules[0].dvs_network_tags
  dgw_firewall_tags = (var.dgw_firewall_tags != null) ? var.dgw_firewall_tags : module.dgw_fw_rules[0].dgw_network_tags
  dgw_image = (var.dgw_image != null) ? var.dgw_image : module.dgw_image[0].image_name
  placement_policy_self_link = (var.placement_policy_self_link != null) ? var.placement_policy_self_link : google_compute_resource_policy.compact_placement[0].self_link
}

# Placement Policy
resource "random_id" "placement_policy_id" {
  byte_length = 4
}

resource "google_compute_resource_policy" "compact_placement" {
  count = var.placement_policy_self_link == null ? 1 : 0
  name  = "rp-compact-placement-${local.environment}-${random_id.placement_policy_id.hex}"
  provider = google-beta

  # Can only be used with A2, A3, C2, C3, C2D, C3D, C4, C4A, G2, H3, N2, and N2D machine types
  group_placement_policy {
    collocation = "COLLOCATED"
    # Place the devices in adjacent racks
    max_distance = 2
  }
}

data "google_compute_image" "ubuntu" {
  project     = "ubuntu-os-cloud"
  most_recent = true
  filter      = "(architecture = \"X86_64\") AND (family = \"ubuntu-2204-lts\") AND (name = \"ubuntu-2204-jammy-*\") AND (status = \"READY\")"
}


# Dante Virtual Soundcard

module "dvs_fw_rules" {
  count  = var.dvs_firewall_tags == null ? 1 : 0
  source = "../../modules/common-modules/dvs/firewall"
  environment = local.environment
  network_self_link = var.vpc_self_link
}

module "dvs_256" {
  count              = 1
  source             = "../../modules/virtual-soundcard"
  environment        = local.environment
  firewall_tags      = local.dvs_firewall_tags
  subnet_self_link   = var.subnet_self_link
  machine_type       = var.machine_type
  installer_version  = var.dvs_version
  dns_domain         = var.dns_domain
  placement_policy   = local.placement_policy_self_link
  # With max_distance=2, the only valid maintenance_policy is TERMINATE
  maintenance_policy = "TERMINATE"
  channel_count      = 256
}

module "dvs_64" {
  count              = 1
  source             = "../../modules/virtual-soundcard"
  environment        = local.environment
  firewall_tags      = local.dvs_firewall_tags
  subnet_self_link   = var.subnet_self_link
  machine_type       = var.machine_type
  installer_version  = var.dvs_version
  dns_domain         = var.dns_domain
  placement_policy   = local.placement_policy_self_link
  # With max_distance=2, the only valid maintenance_policy is TERMINATE
  maintenance_policy = "TERMINATE"
  channel_count      = 64
}

# Dante Gateway

module "dgw_fw_rules" {
  count             = var.dgw_firewall_tags == null ? 1 : 0
  source            = "../../modules/common-modules/dgw/firewall"
  environment       = local.environment
  network_self_link = var.vpc_self_link
}

module "dgw_image" {
  count       = var.dgw_image == null ? 1 : 0
  source      = "../../modules/common-modules/gce/dante-linux-image"
  environment = local.environment
}

module "dgw_64" {
  count                  = 1
  source                 = "../../modules/gateway"
  environment            = local.environment
  firewall_tags          = local.dgw_firewall_tags
  subnet_self_link       = var.subnet_self_link
  machine_image          = local.dgw_image
  machine_type           = var.machine_type
  installer_version      = var.dgw_version
  dns_domain             = var.dns_domain
  placement_policy       = local.placement_policy_self_link
  # With max_distance=2, the only valid maintenance_policy is TERMINATE
  maintenance_policy     = "TERMINATE"
  licensed_channel_count = 64
}
