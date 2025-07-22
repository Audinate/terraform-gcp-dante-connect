#
# File : data.tf
# Created : Nov 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
data "google_compute_image" "ubuntu" {
  project     = "ubuntu-os-cloud"
  most_recent = true
  filter      = "(architecture = \"X86_64\") AND (family = \"ubuntu-2204-lts\") AND (name = \"ubuntu-2204-jammy-*\") AND (status = \"READY\")"
}