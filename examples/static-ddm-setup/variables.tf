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

variable "ddm_ip" {
  description = "The private IPv4 of the DDM"
  type        = string
}

variable "ddm_hostname" {
  description = "(Optional) The hostname of the DDM"
  type        = string
  default     = null
  nullable    = true
}

variable "ddm_port" {
  description = "(Optional) The port of the DDM used for device communication"
  type        = string
  default     = null
  nullable    = true
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

variable "zone" {
  description = "(Optional) The zone the instances will be created in. If excluded, will select an available zone"
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
