#
# File : outputs.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "lb_ip" {
  value = var.create_lb ? module.lb[0].ip : null
}
