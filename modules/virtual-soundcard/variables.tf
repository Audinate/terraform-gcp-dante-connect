#
# File : variables.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "machine_type" {
  description = <<-EOT
  (Optional) The machine type to use for the instance. Updates to this field will trigger a stop/start of the instance.
  EOT
  type        = string
  default     = "n4-standard-4"
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
variable "license_key" {
  description = "(Optional) The DVS license provided by Audinate"
  type        = string
  sensitive   = true
  nullable    = true
  default     = null
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

variable "license_server" {
  type = object({
    hostname = string
    api_key  = string
  })
  nullable = false
  validation {
    condition     = var.license_server != null ? ((var.license_server.api_key != null) && (var.license_server.hostname != null)) : true
    error_message = "When overriding BOTH the hostname and api key must be provided."
  }
  default = {
    hostname = "https://software-license-danteconnect.svc.audinate.com"
    api_key  = "638hPLfZd3nvZ4tXP"
  }

}

variable "audio_driver" {
  description = "(Optional) The audio driver format to be used."
  type        = string
  default     = "asio"
  nullable    = false
  validation {
    condition     = contains(["asio", "wdm"], var.audio_driver)
    error_message = "Invalid DVS audio driver. Valid values = [asio, wdm]"
  }
}

variable "channel_count" {
  description = "(Optional) The number of channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.channel_count != null ? contains([2, 4, 8, 16, 32, 48, 64, 128, 192, 256], var.channel_count) : true
    error_message = "Invalid DVS channel count. Valid values = [2, 4, 8, 16, 32, 48, 64, 128, 192, 256]"
  }
}

variable "licensed_channel_count" {
  description = "(Optional) The number of licensed channels"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.licensed_channel_count != null ? contains([64, 256], var.licensed_channel_count) : true
    error_message = "Invalid DVS licensed channel count. Valid values = [64, 256]"
  }
}

variable "latency" {
  description = "(Optional) The latency threshold in milliseconds"
  type        = number
  default     = 10
  nullable    = false
  validation {
    condition     = contains([4, 6, 10, 20, 40], var.latency)
    error_message = "Invalid DVS latency. Valid values = [4, 6, 10, 20, 40]"
  }
}

variable "install_reaper" {
  description = "(Optional) True to install REAPER on the DVS for advanced testing"
  type        = bool
  default     = false
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
  description = "(Optional) The version of the DVS to be installed"
  type        = string
  nullable    = false
  default     = "4.5.0.5"
}

variable "resource_url" {
  description = "(Optional) The url to download the DVS installer and tools"
  type        = string
  nullable    = false
  default     = "https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/dvs"
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

variable "instance_name" {
  description = "(Optional) The name of the instance"
  type        = string
  default     = null
}

variable "firewall_tags" {
  description = "A list of firewall tags the DVS instance will be associated with."
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
  description = "(Optional) The networking tier used for configuring this instance. This field can take the following values: PREMIUM, FIXED_STANDARD or STANDARD."
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
  (Optional) The DNS domain name which is used for the DDM. This must match the DNS domain name containing the discovery
  records for your DDM, and the domain must be visible to this DVS instance.
  EOT
  type        = string
  default     = null
  nullable    = true
}

variable "component_name_abbreviation" {
  description = "(Optional) The abbreviated name used for the given DVS"
  type        = string
  default     = "dvs"
  nullable    = false
}
