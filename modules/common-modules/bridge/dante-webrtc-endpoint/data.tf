#
# File : data.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
data "cloudinit_config" "user_data" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "dante-webrtc-cloud-init.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${local.shared_dante_webrtc_endpoint_scripts_path}/dante-webrtc-cloud-init.yaml.tftpl", {
      dns_domain = var.dns_domain
      dante_webrtc_endpoint_installation = {
        script  = local.dante_webrtc_endpoint_installation_script
        version = var.installer_version
        url     = var.resource_url
      }
      dante_webrtc_endpoint_configuration_script = local.dante_webrtc_endpoint_configuration_script
    })
  }
}

# Fetch the target network by the provided subnet
data "google_compute_subnetwork" "target" {
  self_link = var.subnet_self_link
}
