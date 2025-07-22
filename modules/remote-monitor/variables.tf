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

variable "firewall_tags" {
  description = "A list of firewall tags the Remote Monitor instance will be associated with."
  type        = set(string)
}

variable "subnet_self_link" {
  description = "The VPC Subnet the instance's network interface will be associated with."
  type        = string
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
  The self_link of the placement policy to attach to the instance. Compact placement policies can be used to improve
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
}

variable "volume_size" {
  description = "(Optional) Size of the volume in gigabytes."
  type        = number
  default     = null
}

variable "dns_domain" {
  description = "(Optional) The DNS domain name which is used for the DDM. Required for DDM DNS Discovery."
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
  description = <<-EOT
    (Optional) Must be provided in case DDM DNS Discovery is not set-up.
    If provided, the ip is required, the hostname and port are optional.
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

variable "audio_settings" {
  type = object({
    rxChannels  = number
    rxLatencyUs = number
  })
  default     = null
  nullable    = true
  description = <<-EOT
    (Optional) the audio settings in the following format:
    audio_settings = {
      rxChannels  = "The number of RX channels"
      rxLatencyUs = "Asymmetric latency for RX in microseconds"
    }
  EOT
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "component_name_abbreviation" {
  description = "(Optional) The abbreviated name used for the given Remote Monitor."
  type        = string
  default     = "rm"
  nullable    = false
}

variable "installer_version" {
  description = "(Optional) The version of the Remote Monitor to be installed"
  type        = string
  default     = "1.0.1.3"
  nullable    = false
}

variable "resource_url" {
  description = "(Optional) The url to download a remote-monitor installer"
  type        = string
  nullable    = false
  default     = "https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/remote-monitor"
}

variable "create_lb" {
  description = <<-EOT
  (Optional) If true, a load balancer in front of the Remote Monitor (to perform HTTPS termination) and required
  firewall rules will be created.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "associate_public_ephemeral_ip_address" {
  description = <<-EOT
  Should create a public ephemeral IP. Either `associate_public_ephemeral_ip_address` or
  `associate_public_static_ip_address` should be true in case you do not use a TURN server.
  EOT
  type        = bool
  default     = true
  nullable    = false
}

variable "associate_public_static_ip_address" {
  description = <<-EOT
  Should create a public static IP. Either `associate_public_ephemeral_ip_address` or
  `associate_public_static_ip_address` should be true in case you do not use a TURN server.
  EOT
  type        = bool
  default     = false
  nullable    = false
}

variable "public_static_ip_network_tier" {
  description = <<-EOT
  (Optional) Applicable only if `associate_public_static_ip_address` is true. The networking tier used for configuring the public
  static IP address. Possible values are: PREMIUM, STANDARD.
  EOT
  type        = string
  default     = null
}

variable "ssl_certificate_self_links" {
  description = "(Optional) Required when create_lb is true. Self links to SSL certificates to associate with the load balancer."
  type        = list(string)
  default     = null
  validation {
    condition     = (!var.create_lb) || (var.ssl_certificate_self_links != null)
    error_message = "If creating a load balancer, the ssl_certificate_self_link must be provided"
  }
}

variable "stun_server_config" {
  description = "(Optional) Stun server configuration provided ex. stun.l.google.com:19302 "
  type        = string
  default     = null
}

variable "turn_server_config" {
  description = "(Optional) Turn server configuration provided ex. [turn:<username>:<password>@<host>:<port>?transport=<tcp|udp|tls>, ...] "
  type        = list(string)
  default     = null
}

variable "license_key" {
  description = "(Optional) The Remote Monitor license provided by Audinate"
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
    license_server = {
      hostname    = "License server hostname"
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

variable "web_admin_account" {
  type = object({
    email    = string
    password = string
  })
  sensitive = true
  nullable  = false
  validation {
    condition     = var.web_admin_account.email != null && var.web_admin_account.password != null
    error_message = "Provide the admin email address and password to log in to Remote Monitor"
  }

  description = <<-EOT
    The account information to log in to Remote Monitor for web administration
    web_admin_account = {
      email      = "Admin email address"
      password   = "Admin password"
    }
  EOT
}

variable "timeout_sec" {
  description = "(Optional) Timeout of the request from the load balancer to the Remote Monitor. Default is 30 seconds. Valid range is [1, 86400]."
  type        = number
  default     = null
}

variable "project" {
  description = "(Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
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
