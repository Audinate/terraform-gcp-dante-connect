#
# File : variables.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "machine_type" {
  description = "(Optional) The machine type to use for the instance. Updates to this field will trigger a stop/start of the instance."
  type        = string
  default     = "n4-standard-4"
  nullable    = false
}

variable "machine_image" {
  description = "The image to use for the instance."
  type        = string
  nullable    = false
}

variable "user_ssh_keys" {
  description = "(Optional) Map of usernames to their SSH public key paths to be able to ssh instance"
  type = list(object({
    user     = string
    key_path = string
  }))
  default = null
}

variable "ddm_address" {
  type = object({
    hostname = optional(string, "")
    ip       = string
    port     = optional(string, "8000")
  })
  nullable    = true
  default     = null
  description = <<-EOT
    (Optional) Must be provided in case DDM DNS Discovery is not set-up.
    If provided, the ip is required, the port defaults to 8000 and the hostname is optional.
    If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.
    ddm_address = {
      hostname = "The hostname of the DDM"
      ip    = "The IPv4 of the DDM"
      port  = "The port of the DDM"
    }
  EOT
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
  nullable    = true
  default     = null
  description = <<-EOT
    (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain
    and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)
    ddm_configuration = {
      api_key      = "The API key to use while performing the configuration"
      api_host     = "The full name (including protocol, host, port and path) of the location of DDM API"
      dante_domain = "The dante domain to use, must be pre-provisioned"
    }
  EOT
}

variable "audio_settings" {
  type = object({
    txChannels  = number
    rxChannels  = number
    txLatencyUs = number
    rxLatencyUs = number
  })
  default     = null
  nullable    = true
  description = <<-EOT
    (Optional) the audio settings in the following format:
    audio_settings = {
      txChannels  = "The number of TX channels"
      rxChannels  = "The number of RX channels"
      txLatencyUs = "Asymmetric latency for TX in microseconds"
      rxLatencyUs = "Asymmetric latency for RX in microseconds"
    }
  EOT
}

variable "volume_size" {
  description = "(Optional) Size of the volume in gigabytes."
  type        = number
  default     = 50
  nullable    = false
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "installer_version" {
  description = "(Optional) The version of the DGW to be installed"
  type        = string
  nullable    = false
  default     = "1.1.1.1"
}

variable "resource_url" {
  description = "(Optional) The url to download a DGW installer"
  type        = string
  nullable    = false
  default     = "https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/dgw"
}

variable "license_key" {
  description = "(Optional) The DGW license provided by Audinate"
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
  description = <<-EOT
    (Optional) License settings
    "license_server" = {
      hostname      = "License server hostname"
      api_key     = "License server api key"
    }
  EOT
}

variable "license_websocket_port" {
  description = "(Optional) License websocket port number"
  type        = number
  nullable    = false
  default     = 49999
}

variable "licensed_channel_count" {
  description = "(Optional) The number of licensed channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.licensed_channel_count != null ? contains([64, 256], var.licensed_channel_count) : true
    error_message = "Invalid DGW licensed channel count. Valid values = [64, 256]"
  }
}

variable "region" {
  description = "(Optional) The Region in which the created addresses should reside. If it is not provided, the provider region is used."
  type        = string
  default     = null
}

variable "zone" {
  description = "(Optional) The zone that the machine should be created in. If it is not provided, the provider zone is used."
  type        = string
  default     = null
}

variable "firewall_tags" {
  description = "A list of firewall tags the Gateway instance will be associated with."
  type        = set(string)
}

variable "subnet_self_link" {
  description = "The VPC Subnet the instance's network interface will be associated with."
  type        = string
}

variable "public_static_ip_network_tier" {
  description = "(Optional) The networking tier used for configuring the public static IP address of the instance. Possible values are: PREMIUM, STANDARD."
  type        = string
  default     = "STANDARD"
  nullable    = false
}

variable "instance_network_tier" {
  description = <<-EOT
  (Optional) The networking tier used for configuring this instance. This field can take the following values:
  PREMIUM, FIXED_STANDARD or STANDARD.
  EOT
  type        = string
  default     = "STANDARD"
  nullable    = false
}

variable "placement_policy" {
  description = <<-EOT
  (Optional) The self_link of the placement policy to attach to the instance. Compact placement policies can be used to improve
  latency. Note that compact placement can be used only with certain machine types.
  EOT
  type        = string
  default     = null
}

variable "maintenance_policy" {
  description = <<-EOT
  (Optional) Describes maintenance behavior for the instance. Defaults to MIGRATE.
  Can be MIGRATE or TERMINATE, for more info, read https://cloud.google.com/compute/docs/instances/setting-instance-scheduling-options.
  EOT
  type        = string
  default     = null
}

variable "nic_type" {
  description = "(Optional) The type of vNIC to be used on this interface. Possible values: GVNIC, VIRTIO_NET."
  type        = string
  default     = "GVNIC"
  nullable    = false
}

variable "dns_domain" {
  description = <<-EOT
  (Optional) The DNS domain name which is used for the DDM. This must match the DNS domain name as of which the
  `managed_zone_name` is provided. When both domain and managed_zone_name are provided required records are written for
  DDM auto discovery.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "component_name_abbreviation" {
  description = "(Optional) The abbreviated name used for the given DGW"
  type        = string
  default     = "dgw"
  nullable    = false
}
