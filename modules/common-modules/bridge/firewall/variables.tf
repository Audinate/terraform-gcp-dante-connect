#
# File : variables.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "network_self_link" {
  description = "The self_link of the VPC network to associate the firewall rules with."
  type        = string
}

variable "component_name_abbreviation" {
  description = "The abbreviated name used for the given Dante WebRTC Endpoint."
  type        = string
}

variable "environment" {
  description = "The name of the environment."
  type        = string
}

variable "project" {
  description = <<-EOT
  (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used.
  EOT
  type        = string
  default     = null
}