#
# File : outputs.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "gce_instance_id" {
  value = google_compute_instance.vm_instance.id
}

output "gce_instance_self_link" {
  value = google_compute_instance.vm_instance.self_link
}

output "gce_instance_zone" {
  value = google_compute_instance.vm_instance.zone
}

output "gce_instance_private_ip" {
  value = google_compute_instance.vm_instance.network_interface[0].network_ip
}

output "gce_instance_name" {
  value = google_compute_instance.vm_instance.name
}

