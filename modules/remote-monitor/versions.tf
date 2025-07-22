#
# File : versions.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.28.0"
    }
  }
}