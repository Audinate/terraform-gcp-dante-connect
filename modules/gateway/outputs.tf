#
# File : outputs.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "dgw_private_ip" {
  value       = module.dgw.gce_instance_private_ip
  description = "Private IP of the Dante Gateway instance"
}
output "dgw_instance_name" {
  value       = module.dgw.gce_instance_name
  description = "Name of Dante Gateway Compute instance"
}
