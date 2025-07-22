#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
locals {
  environment = "test"
  zone = (var.zone != null) ? var.zone : data.google_compute_zones.available.names[0]
  rm_firewall_tags = (var.rm_firewall_tags != null) ? var.rm_firewall_tags : module.rm_firewall_rules[0].bridge_network_tags
  rm_image = (var.rm_image != null) ? var.rm_image : module.rm_image[0].image_name
}

# Remote Monitor

module "rm_firewall_rules" {
  count  = var.rm_firewall_tags == null ? 1 : 0
  source = "../../modules/common-modules/bridge/firewall"
  environment = local.environment
  network_self_link = var.vpc_self_link
  component_name_abbreviation = "rm"
}

module "rm_image" {
  count       = var.rm_image == null ? 1 : 0
  source      = "../../modules/common-modules/gce/dante-linux-image"
  environment = local.environment
}

module "remote_monitor" {
  count                      = 1
  source                     = "../../modules/remote-monitor"
  environment                = local.environment
  firewall_tags              = local.rm_firewall_tags
  subnet_self_link           = var.subnet_self_link
  machine_image              = local.rm_image
  zone                       = local.zone
  dns_domain                 = var.dns_domain
  create_lb                  = true
  ssl_certificate_self_links = compact([ var.ssl_certificate_self_link ])
  web_admin_account = {
    email    = var.web_admin_email
    password = var.web_admin_password
  }
  installer_version          = var.rm_version
}

# NOTE:
# The provider treats this resource as an authoritative record set. This means existing records
# (including the default records) for the given type will be overwritten when you create this resource in Terraform.
# In addition, the Google Cloud DNS API requires NS and SOA records to be present at all times, so Terraform will not
# actually remove NS or SOA records on the root of the zone during destroy but will report that it did.
resource "google_dns_record_set" "cloud_dns_record" {
  count = length(module.remote_monitor)

  managed_zone = var.managed_zone_name
  name = (
    "remote-monitor-${count.index}.${data.google_dns_managed_zone.monitor_zone.dns_name}"
  )
  type    = "A"
  ttl     = 60
  rrdatas = [module.remote_monitor[count.index].lb_ip]
}
