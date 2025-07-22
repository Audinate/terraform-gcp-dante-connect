#
# File : variables.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "The ID of the project"
  type        = string
  default     = null
}

variable "network_self_link" {
  description = <<-EOT
  The self_link of the VPC network to associate the
  default firewall rules with.
  EOT
  type        = string
}

variable "component_name_abbreviation" {
  description = "The abbreviated name used for the given DVS"
  type        = string
  default     = "dvs"
  nullable    = false
}