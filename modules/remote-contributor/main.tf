#
# File : main.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  license_key     = var.license_key != null ? var.license_key : "APHZL-YLVRR-RN67L-V5WYU-AGTC3"
}

module "remote_contributor" {
  source = "../common-modules/bridge/dante-webrtc-endpoint"

  project       = var.project
  region        = var.region
  zone          = var.zone
  environment   = var.environment

  machine_type                          = var.machine_type
  volume_size                           = var.volume_size
  machine_image                         = var.machine_image
  associate_public_ephemeral_ip_address = var.associate_public_ephemeral_ip_address
  associate_public_static_ip_address    = var.associate_public_static_ip_address
  subnet_self_link                      = var.subnet_self_link
  firewall_tags                         = var.firewall_tags
  instance_network_tier                 = var.instance_network_tier
  nic_type                              = var.nic_type
  public_static_ip_network_tier         = var.public_static_ip_network_tier
  placement_policy                      = var.placement_policy
  maintenance_policy                    = var.maintenance_policy
  dns_domain                            = var.dns_domain
  ddm_address                           = var.ddm_address
  ddm_configuration                     = var.ddm_configuration
  audio_settings = var.audio_settings == null ? null : {
    rxChannels = var.audio_settings.rxChannels
    txChannels = var.audio_settings.txChannels
    rxLatencyUs = var.audio_settings.rxLatencyUs
    txLatencyUs = var.audio_settings.txLatencyUs
  }
  component_name_abbreviation           = var.component_name_abbreviation
  create_lb                             = var.create_lb
  ssl_certificate_self_links            = var.ssl_certificate_self_links
  stun_server_config                    = var.stun_server_config
  turn_server_config                    = var.turn_server_config
  license_server                        = var.license_server
  license_websocket_port                = var.license_websocket_port
  web_admin_account                     = var.web_admin_account
  timeout_sec                           = var.timeout_sec

  license_key                           = local.license_key
  installer_version                     = var.installer_version
  resource_url                          = var.resource_url
  product_identifiers = {
    product_abbreviation = "rc"
    service_name = "remote-contributor"
    product_name = "remote-contributor"
  }
}