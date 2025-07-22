#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

variable "subnet_self_link" {
  description = "The subnet this instance will be associated with. The subnet's self link can be determined by running `gcloud compute networks subnets describe <subnet_name> --region=<region_name> --format='default(selfLink)'`"
  type        = string
}

variable "region" {
  description = "Region the instances will be created in"
  type        = string
}

variable "project" {
  description = "The project ID of the GCP project the instances will be created in"
  type        = string
}

variable "zone" {
  description = "The zone the instances will be created in. Make sure to select a region in which your selected machine type is available."
  type        = string
}

variable "placement_policy_self_link" {
  description = <<-EOT
  (Optional) The self link for the (compact) placement policy to put these devices in. If not provided, a new placement policy is created
  You can see the self links for all your placement policies by running `gcloud compute resource-policies list --uri`
  EOT
  type        = string
  default     = null
}

variable "machine_type" {
  description = "(Optional) The machine type to use for the instances. The chosen machine type must be compatible with the placement policy. See https://cloud.google.com/compute/docs/instances/placement-policies-overview for details"
  type        = string
  default     = "c4-standard-4"
  nullable    = false
}

variable "vpc_self_link" {
  description = "(Optional) The vpc for instance firewall rules to be created in. The VPC self link can be determined by running `gcloud compute networks describe <vpc_name> --format='default(selfLink)`"
  type        = string
  default     = null
  validation {
    condition     = var.vpc_self_link != null || (var.dvs_firewall_tags != null && var.dgw_firewall_tags != null)
    error_message = "If manually created firewall tags are not provided, the vpc self link must be given to create firewall rules."
  }
}

variable "dns_domain" {
  description = "(Optional) The domain name suffix of the DNS containing the DDM SRV discovery records. For example if the device SRV record is `default._dante-ddm-d._udp.my.domain.internal.` this should be `my.domain.internal.`"
  type        = string
  default     = null
}

variable "dvs_firewall_tags" {
  description = "(Optional) The set of firewall tags which should be applied to the DVS instances. If excluded, firewall rules will be created automatically."
  type        = set(string)
  default     = null
}

variable "dvs_version" {
  description = "(Optional) The version of DVS to be installed"
  type        = string
  default     = null
}

variable "dgw_image" {
  description = "(Optional) The image used to initialise the Dante Gateway instances. This image must have the MULTI_IP_SUBNET guest os feature. If excluded, a new custom ubuntu image will be created. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#image-1 for format"
  type        = string
  default     = null
}

variable "dgw_firewall_tags" {
  description = "(Optional) The set of firewall tags which should be applied to the Dante Gateway instances. If excluded, firewall rules will be created automatically."
  type        = set(string)
  default     = null
}

variable "dgw_version" {
  description = "(Optional) The version of Dante Gateway to be installed"
  type        = string
  default     = null
}
