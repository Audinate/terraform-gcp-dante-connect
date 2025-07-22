#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
data "google_compute_zones" "available" {
  project = var.project
  region  = var.region
  status  = "UP"
}

data "google_dns_managed_zone" "monitor_zone" {
  name = var.managed_zone_name
}