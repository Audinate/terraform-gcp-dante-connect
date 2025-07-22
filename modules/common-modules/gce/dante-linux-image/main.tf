#
# File : main.tf
# Created : Nov 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

resource "random_id" "random" {
  byte_length = 4

  keepers = {
    # Generate a new id each time we switch to a new image
    image_id = data.google_compute_image.ubuntu.self_link
  }
}

resource "google_compute_image" "multi_ip_subnet_image" {
  name         = "multi-ip-subnet-image-${var.environment}-${random_id.random.hex}"
  source_image = data.google_compute_image.ubuntu.self_link
  description  = "Ubuntu Image for Dante Connect with multi-ip-subnet feature. Created by Terraform"
  project      = var.project

  guest_os_features {
    type = "MULTI_IP_SUBNET"
  }
}