#
# File : outputs.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
output "lb_ip" {
  description = "The external ip of the load balancer which forwards to the Remote Contributor. Null if the LB was not created"
  value = module.remote_contributor.lb_ip
}
