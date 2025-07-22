#
# File : variables.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#
variable "image" {
  description = "The image from which to initialize this disk."
  type        = string
}

variable "machine_type" {
  description = "The machine type to use for the instance. Updates to this field will trigger a stop/start of the instance."
  type        = string
}

variable "subnet_self_link" {
  description = <<-EOT
  The VPC Subnet the instance's network interface and static internal IP (if applicable) will be associated with.
  EOT
  type        = string
}

variable "volume_size" {
  description = "Size of the volume in gigabytes."
  type        = number
}

variable "metadata" {
  description = "Metadata key/value pairs to make available from within the instance."
  type        = map(string)
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "environment" {
  description = "The name of the environment"
  type        = string
}

variable "associate_public_ephemeral_ip_address" {
  description = <<-EOT
  Should create a public ephemeral IP. Only one of `associate_public_ephemeral_ip_address` and
  `associate_public_static_ip_address` may be true.
  EOT
  type        = bool
  default     = false
}

variable "associate_public_static_ip_address" {
  description = <<-EOT
  Should create a public static IP. Only one of `associate_public_ephemeral_ip_address` and
  `associate_public_static_ip_address` may be true.
  EOT
  type        = bool
  default     = false
}

variable "public_static_ip_network_tier" {
  description = <<-EOT
  Applicable only if `associate_public_static_ip_address` is true. The networking tier used for configuring the public
  static IP address. Possible values are: PREMIUM, STANDARD.
  EOT
  type        = string
}

variable "associate_internal_static_ip_address" {
  description = "Should create an internal static IP."
  type        = bool
  default     = false
}

variable "nic_type" {
  description = "The type of vNIC to be used on this interface. Possible values: GVNIC, VIRTIO_NET."
  type        = string
}

variable "instance_network_tier" {
  description = <<-EOT
  The networking tier used for configuring this instance. This field can take the following values: PREMIUM,
  FIXED_STANDARD or STANDARD.
  EOT
  type        = string
}

variable "enable_virtual_displays" {
  description = "Enable Virtual Displays on this instance."
  type        = bool
}

variable "source_dest_check" {
  description = "Whether to enable source destination checking for the instance."
  type        = bool
  default     = true
}

variable "firewall_tags" {
  description = "The firewall tags to associate with the instance."
  type        = set(string)
}

variable "project" {
  description = "The ID of the project in which the resource belongs. If it is not provided, the provider project is used."
  type        = string
  default     = null
}

variable "region" {
  description = "The Region in which the created addresses should reside. If it is not provided, the provider region is used."
  type        = string
  default     = null
}

variable "zone" {
  description = "The zone that the machine should be created in. If it is not provided, the provider zone is used."
  type        = string
  default     = null
}

variable "service_account" {
  description = "The name of the Service Account to launch the instance with."
  type        = string
  default     = null
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