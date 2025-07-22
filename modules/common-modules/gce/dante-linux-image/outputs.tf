#
# File : outputs.tf
# Created : Nov 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

output "image_name" {
  value = google_compute_image.multi_ip_subnet_image.name
}