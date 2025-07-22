#
# File : outputs.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "ip" {
  value = google_compute_global_address.frontend.address
}