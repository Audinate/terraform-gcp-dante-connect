#
# File : outputs.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "dvs_private_ip" {
  value       = module.dvs.gce_instance_private_ip
  description = "Private IP of the Dante Virtual Soundcard instance"
}
output "dvs_instance_name" {
  value       = module.dvs.gce_instance_name
  description = "Name of Dante Virtual Soundcard Compute instance"
}