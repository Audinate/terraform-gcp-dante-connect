#
# File : data.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
data "google_compute_image" "windows_server_2022" {
  family      = "windows-2022"
  project     = "windows-cloud"
  most_recent = true
}

