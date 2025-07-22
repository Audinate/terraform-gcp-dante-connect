#
# File : outputs.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

output "lb_ip" {
  description = "The external ip of the load balancer which forwards to the Remote Monitor. Null if the LB was not created"
  value = module.remote_monitor.lb_ip
}
