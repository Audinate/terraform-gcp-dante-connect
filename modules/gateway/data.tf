#
# File : data.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

data "cloudinit_config" "startup_script" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "dgw-cloud-init.yaml"
    content_type = "text/cloud-config"

    content = templatefile("${local.shared_dgw_scripts_path}/dgw-cloud-init.yaml.tftpl", {
      dgw_installation = {
        script  = local.dgw_installation_script
        version = var.installer_version
        url     = var.resource_url
      }
      dns_domain               = var.dns_domain
      dgw_configuration_script = local.dgw_configuration_script
    })
  }
}
