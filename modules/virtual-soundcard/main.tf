#
# File : main.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  license_keys = {
    "64"  = "6PDZW-HAT54-QMS7B-4SEB7-SOOYS"
    "256" = "NISBH-ZQG2O-KAKHZ-XHYWZ-IA32H"
  }
  instance_name                = (var.instance_name != null) ? var.instance_name : "vm-${var.component_name_abbreviation}-${var.environment}-${random_id.random.hex}"
  license_counts               = [for count in keys(local.license_keys) : tonumber(count)]
  channel_count                = (var.channel_count != null) ? var.channel_count : min(local.license_counts...)
  licensed_channel_count       = (var.licensed_channel_count != null) ? var.licensed_channel_count : min([for count in local.license_counts : count if count >= local.channel_count]...)
  license_key                  = (var.license_key != null) ? var.license_key : local.license_keys[local.licensed_channel_count]
  installer_version            = var.installer_version
  instance_type                = var.machine_type == null ? "n4-standard-4" : var.machine_type
  shared_dvs_scripts_path      = "${path.module}/../shared-scripts/dvs"
  dvs_installation_script      = file("${local.shared_dvs_scripts_path}/dvs-installation.ps1")
  dvs_configuration_script = templatefile("${local.shared_dvs_scripts_path}/dvs-configuration.ps1.tftpl", {
    dvs_license           = local.license_key,
    ddm_address           = var.ddm_address,
    audio_driver          = var.audio_driver,
    channel_count         = local.channel_count,
    latency               = var.latency,
    licenseServerHostname = var.license_server != null ? var.license_server.hostname : null,
    licenseServerApiKey   = var.license_server != null ? var.license_server.api_key : null
  })
  reaper_installation_script = templatefile("${local.shared_dvs_scripts_path}/dvs-install-reaper.ps1.tftpl", {
    install_reaper = var.install_reaper
  })
  dns_set_up_script = templatefile("${local.shared_dvs_scripts_path}/dns-setup.tftpl", {
    change_domain = var.dns_domain != null ? true : false,
    domain        = var.dns_domain
  })
  disable_wuauserv = file("${local.shared_dvs_scripts_path}/disable-wuauserv.ps1")
}

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    image = data.google_compute_image.windows_server_2022.self_link
  }
}

module "dvs" {
  source = "../common-modules/gce/instance"

  instance_name = local.instance_name
  project       = var.project
  region        = var.region
  zone          = var.zone
  environment   = var.environment


  machine_type                         = var.machine_type
  volume_size                          = var.volume_size
  image                                = data.google_compute_image.windows_server_2022.self_link
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
    osconfig-disabled-features = "osinventory,tasks"
    ssh-keys                   = var.user_ssh_keys != null ? join("\n", [for ssh_key in var.user_ssh_keys : "${ssh_key.user}:${file(ssh_key.key_path)}"]) : null
    sysprep-specialize-script-ps1 = <<-EOT
    Write-Output "Start DVS system preparation scripts..."
    $Env:DVS_VERSION = "${local.installer_version}"
    $Env:DVS_RESOURCE_URL = "${var.resource_url}"
    ${local.dns_set_up_script}
    ${local.disable_wuauserv}
    ${local.dvs_installation_script}
    ${local.reaper_installation_script}
    write-Output "Finish DVS system preparation scripts..."
    EOT
    windows-startup-script-ps1 = <<-EOT
    Write-Output "Start  start up scripts..."
    ${local.dvs_configuration_script}
    Write-Output "Stop Executing start up scripts..."
    EOT
  }
}



module "dvs_ddm_script" {
  source = "../configuration"

  enroll_device     = (var.ddm_configuration != null)
  ip_address        = module.dvs.gce_instance_private_ip
  ddm_configuration = var.ddm_configuration

  depends_on = [module.dvs]
}



