#
# File : variables.tf
# Created : May 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "component_name_abbreviation" {
  description = "The abbreviated name used for the given Bridge"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "instance_suffix" {
  description = "The suffix used in the Bridge's instance name"
  type        = string
}

variable "ssl_certificate_self_links" {
  description = "Self links to SSL certificates used to authenticate connections between users and the load balancer."
  type        = list(string)
}

variable "timeout_sec" {
  description = <<-EOT
  How many seconds to wait for the backend before considering it a failed request. Default is 30 seconds.
  Valid range is [1, 86400].
  EOT
  type        = number
}

variable "instance_self_link" {
  description = "The self link of the bridge to associate with the backend service of the load balancer."
  type        = string
}

variable "instance_zone" {
  description = "The zone of the bridge to associate with the backend service of the load balancer."
  type        = string
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}
