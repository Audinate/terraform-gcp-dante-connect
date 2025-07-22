#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
terraform {
  required_version = ">= 1.8.3"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.28.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}