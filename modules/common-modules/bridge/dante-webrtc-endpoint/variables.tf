#
# File : variables.tf
# Created : November 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "machine_type" {
  type        = string
  default     = "n4-standard-4"
  nullable    = false
}

variable "machine_image" {
  type        = string
  nullable    = false
}

variable "firewall_tags" {
  type        = set(string)
}

variable "subnet_self_link" {
  type        = string
}

variable "instance_network_tier" {
  type        = string
  default     = "STANDARD"
}

variable "placement_policy" {
  type        = string
  default     = null
}

variable "maintenance_policy" {
  type        = string
  default     = null
}

variable "nic_type" {
  type        = string
  default     = "GVNIC"
}

variable "volume_size" {
  type        = number
  default     = null
}

variable "dns_domain" {
  type        = string
  default     = null
  nullable    = true
}

variable "ddm_address" {
  type = object({
    hostname = optional(string, "")
    ip       = string
    port     = optional(string, "8000")
  })
  nullable    = true
  default     = null
  validation {
    condition     = var.ddm_address == null ? true : var.ddm_address.ip == "" || can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.ddm_address.ip))
    error_message = "Provided IP is not a valid IP version 4 address"
  }
}

variable "ddm_configuration" {
  type = object({
    api_key      = string
    api_host     = string
    dante_domain = string
  })
  default     = null
}

variable "audio_settings" {
  type = object({
    rxChannels  = number
    txChannels  = number
    rxLatencyUs = number
    txLatencyUs = number
  })
  nullable    = true
}

variable "environment" {
  type        = string
}

variable "product_identifiers" {
  type = object({
    service_name         = string
    product_name         = string
    product_abbreviation = string 
  })
  description = "Names of the product to use in automated scripts"
}

variable "component_name_abbreviation" {
  type        = string
}

variable "installer_version" {
  type        = string
}

variable "resource_url" {
  type        = string
  nullable    = false
}

variable "create_lb" {
  type        = bool
  default     = false
  nullable    = false
}

variable "associate_public_ephemeral_ip_address" {
  type        = bool
  default     = true
  nullable    = false
}

variable "associate_public_static_ip_address" {
  type        = bool
  default     = false
  nullable    = false
}

variable "public_static_ip_network_tier" {
  type        = string
  default     = null
}

variable "ssl_certificate_self_links" {
  type        = list(string)
  default     = null
}

variable "stun_server_config" {
  type        = string
  default     = null
}

variable "turn_server_config" {
  type        = list(string)
  default     = null
}

variable "license_key" {
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
}

variable "license_server" {
  type = object({
    hostname = string
    api_key  = string
  })
  nullable = false
  default = {
    hostname = "https://software-license-danteconnect.svc.audinate.com"
    api_key  = "638hPLfZd3nvZ4tXP"
  }
}

variable "license_websocket_port" {
  description = "License websocket port number"
  type        = number
  nullable    = false
  default     = 49999
}

variable "web_admin_account" {
  type = object({
    email    = string
    password = string
  })
  sensitive = true
  nullable  = false
  validation {
    condition     = var.web_admin_account.email != null && var.web_admin_account.password != null
    error_message = "Provide the admin email address and password to log in to Remote Monitor/Contributor"
  }
}

variable "timeout_sec" {
  type        = number
  default     = null
}

variable "project" {
  type        = string
  default     = null
}

variable "region" {
  type        = string
  default     = null
}

variable "zone" {
  type        = string
  default     = null
}
