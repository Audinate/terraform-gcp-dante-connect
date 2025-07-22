#
# File : variables.tf
# Created : Nov 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "The ID of the project. Defaults to the provider project"
  type        = string
  default     = null
}
