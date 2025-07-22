#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  license_keys = {
    "64"  = "VOHCA-43JSH-SQOW7-LQPDP-QKOOV"
    "256" = "BXS6K-R7UIL-T3UV5-XAJBZ-6TE6L"
  }
  license_counts         = [for count in keys(local.license_keys) : tonumber(count)]
  has_channel_count      = var.audio_settings == null ? false : var.audio_settings.txChannels != null && var.audio_settings.rxChannels != null
  channel_count          = local.has_channel_count ? max(var.audio_settings.txChannels, var.audio_settings.rxChannels) : min(local.license_counts...)
  licensed_channel_count = (var.licensed_channel_count != null) ? var.licensed_channel_count : min([for count in local.license_counts : count if count >= local.channel_count]...)
  license_key            = (var.license_key != null) ? var.license_key : local.license_keys[local.licensed_channel_count]
  instance_name          = "vm-${var.component_name_abbreviation}-${var.environment}-${random_id.random.hex}"

  dep_setup_vars = {
    ddm_address            = var.ddm_address
    audio_settings         = var.audio_settings
    license_key            = local.license_key
    license_server         = var.license_server
    license_websocket_port = var.license_websocket_port
    licensed_channel_count = local.licensed_channel_count
  }
  shared_dgw_scripts_path  = "${path.module}/../shared-scripts/dgw"
  dgw_installation_script  = file("${local.shared_dgw_scripts_path}/dgw-setup.sh")
  dgw_configuration_script = templatefile("${local.shared_dgw_scripts_path}/dgw-configuration.sh.tftpl", local.dep_setup_vars)
}

module "dgw" {
  source = "../common-modules/gce/instance"

  project     = var.project
  region      = var.region
  zone        = var.zone
  environment = var.environment

  instance_name                        = local.instance_name
  machine_type                         = var.machine_type
  volume_size                          = var.volume_size
  image                                = var.machine_image
  associate_internal_static_ip_address = false
  associate_public_static_ip_address   = true
  subnet_self_link                     = var.subnet_self_link
  firewall_tags                        = var.firewall_tags
  instance_network_tier                = var.instance_network_tier
  nic_type                             = var.nic_type
  public_static_ip_network_tier        = var.public_static_ip_network_tier
  enable_virtual_displays              = false
  placement_policy                     = var.placement_policy
  maintenance_policy                   = var.maintenance_policy

  metadata = {
    ssh-keys                   = var.user_ssh_keys != null ? join("\n", [for ssh_key in var.user_ssh_keys : "${ssh_key.user}:${file(ssh_key.key_path)}"]) : null
    startup-script             = <<-CLOUD_INIT
      #!/bin/bash
      command -v cloud-init &>/dev/null || (apt-get install -y cloud-init && reboot)
    CLOUD_INIT
    user-data                  = data.cloudinit_config.startup_script.rendered
    osconfig-disabled-features = "osinventory,tasks"
  }
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    image = var.machine_image
  }
}

module "dgw_ddm_script" {
  source = "../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dgw.gce_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dgw]
}
