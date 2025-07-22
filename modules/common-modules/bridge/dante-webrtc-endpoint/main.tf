#
# File : main.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  instance_suffix = random_id.random.hex
  webrtc_endpoint_setup_vars = {
    identifiers = var.product_identifiers
    installer_version = var.installer_version
    resource_url = var.resource_url
  }
  webrtc_endpoint_config_vars = {
    ddm_address            = var.ddm_address
    audio_settings         = var.audio_settings
    license_key            = var.license_key
    license_server         = var.license_server
    license_websocket_port = var.license_websocket_port
    stun_server_config     = var.stun_server_config
    turn_server_config     = var.turn_server_config != null ? join(" ", var.turn_server_config) : null
    web_admin_account      = var.web_admin_account
    identifiers            = var.product_identifiers
  }
  shared_dante_webrtc_endpoint_scripts_path  = "${path.module}/../../../shared-scripts/dante-webrtc-endpoint"
  dante_webrtc_endpoint_installation_script  = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-setup.sh.tftpl", local.webrtc_endpoint_setup_vars)
  dante_webrtc_endpoint_configuration_script = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-configuration.sh.tftpl", local.webrtc_endpoint_config_vars)
  firewall_tags = setunion(
    var.firewall_tags,
    (var.create_lb ? setunion(google_compute_firewall.bridge_fw_allow_lb[0].target_tags, google_compute_firewall.bridge_fw_allow_hc[0].target_tags) : [])
  )
}

module "dante_webrtc_endpoint_base" {
  source = "../../gce/instance"

  instance_name = "vm-${var.component_name_abbreviation}-${var.environment}-${local.instance_suffix}"
  project       = var.project
  region        = var.region
  zone          = var.zone
  environment   = var.environment

  machine_type                          = var.machine_type
  volume_size                           = var.volume_size
  image                                 = var.machine_image
  associate_internal_static_ip_address  = false
  associate_public_ephemeral_ip_address = var.associate_public_ephemeral_ip_address
  associate_public_static_ip_address    = var.associate_public_static_ip_address
  subnet_self_link                      = var.subnet_self_link
  firewall_tags                         = local.firewall_tags
  instance_network_tier                 = var.instance_network_tier
  nic_type                              = var.nic_type
  public_static_ip_network_tier         = var.public_static_ip_network_tier
  enable_virtual_displays               = false
  placement_policy                      = var.placement_policy
  maintenance_policy                    = var.maintenance_policy

  metadata = {
    startup-script = <<-CLOUD_INIT
      #!/bin/bash
      command -v cloud-init &>/dev/null || (apt-get install -y cloud-init && reboot)
    CLOUD_INIT
    user-data      = data.cloudinit_config.user_data.rendered
  }
}

module "dante_webrtc_endpoint_ddm_script" {
  source = "../../../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dante_webrtc_endpoint_base.gce_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dante_webrtc_endpoint_base]
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    # Generate a new id each time we switch to a new image
    image = var.machine_image
  }
}

module "lb" {
  count  = var.create_lb ? 1 : 0
  source = "../../bridge/lb"

  project     = var.project
  environment = var.environment

  component_name_abbreviation = var.component_name_abbreviation
  instance_suffix             = local.instance_suffix
  ssl_certificate_self_links  = var.ssl_certificate_self_links
  timeout_sec                 = var.timeout_sec
  instance_self_link          = module.dante_webrtc_endpoint_base.gce_instance_self_link
  instance_zone               = module.dante_webrtc_endpoint_base.gce_instance_zone
}

resource "google_compute_firewall" "bridge_fw_allow_lb" {
  count   = var.create_lb ? 1 : 0
  name    = "fw-${var.component_name_abbreviation}-lb-${var.environment}-${local.instance_suffix}"
  network = data.google_compute_subnetwork.target.network
  project = var.project

  direction     = "INGRESS"
  source_ranges = [module.lb[0].ip]

  target_tags = ["${var.component_name_abbreviation}-allow-lb"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "bridge_fw_allow_hc" {
  count   = var.create_lb ? 1 : 0
  name    = "fw-${var.component_name_abbreviation}-hc-${var.environment}-${local.instance_suffix}"
  network = data.google_compute_subnetwork.target.network
  project = var.project

  direction     = "INGRESS"
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]

  target_tags = ["${var.component_name_abbreviation}-allow-hc"]

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}