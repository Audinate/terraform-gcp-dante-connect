#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
  zone = (var.zone != null) ? var.zone : data.google_compute_zones.available.names[0]
  dvs_firewall_tags = (var.dvs_firewall_tags != null) ? var.dvs_firewall_tags : module.dvs_fw_rules[0].dvs_network_tags
  dgw_firewall_tags = (var.dgw_firewall_tags != null) ? var.dgw_firewall_tags : module.dgw_fw_rules[0].dgw_network_tags
  dgw_image = (var.dgw_image != null) ? var.dgw_image : module.dgw_image[0].image_name
}

# Dante Virtual Soundcard

module "dvs_fw_rules" {
  count  = var.dvs_firewall_tags == null ? 1 : 0
  source = "../../modules/common-modules/dvs/firewall"
  environment = local.environment
  network_self_link = var.vpc_self_link
}

module "dvs_256" {
  count             = 1
  source            = "../../modules/virtual-soundcard"
  environment       = local.environment
  firewall_tags     = local.dvs_firewall_tags
  subnet_self_link  = var.subnet_self_link
  zone              = local.zone
  installer_version = var.dvs_version
  dns_domain        = var.dns_domain

  channel_count = 192
  latency       = 20

  ddm_configuration = {
    api_key      = var.ddm_api_key
    api_host     = var.ddm_api_host
    dante_domain = var.dante_domain
  }
}

module "dvs_64" {
  count             = 1
  source            = "../../modules/virtual-soundcard"
  environment       = local.environment
  firewall_tags     = local.dvs_firewall_tags
  subnet_self_link  = var.subnet_self_link
  zone              = local.zone
  installer_version = var.dvs_version
  dns_domain        = var.dns_domain

  channel_count = 16
  latency       = 10

  ddm_configuration = {
    api_key      = var.ddm_api_key
    api_host     = var.ddm_api_host
    dante_domain = var.dante_domain
  }
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
  installer_version      = var.dgw_version
  dns_domain             = var.dns_domain
  zone                   = local.zone

  audio_settings = {
    txChannels  = 64
    rxChannels  = 64
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }

  ddm_configuration = {
    api_key      = var.ddm_api_key
    api_host     = var.ddm_api_host
    dante_domain = var.dante_domain
  }
}
