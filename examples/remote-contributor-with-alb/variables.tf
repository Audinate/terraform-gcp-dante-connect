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

variable "ssl_certificate_self_link" {
  description = "The self link of the global ssl certificate to be used in the load balancer. This can be determined using `gcloud compute ssl-certificates describe <your_certificate> --format='default(selfLink)'`"
  type        = string
}

variable "web_admin_email" {
  description = "The admin email address to log in to Remote Contributor"
  type        = string
  sensitive   = true
}

variable "web_admin_password" {
  description = "The admin password to log in to Remote Contributor"
  type        = string
  sensitive   = true
}

variable "managed_zone_name" {
  description = "The name of the managed DNS zone to place the Remote Contributor A record in."
  type        = string
}

variable "vpc_self_link" {
  description = "(Optional) The vpc for instance firewall rules to be created in. The VPC self link can be determined by running `gcloud compute networks describe <vpc_name> --format='default(selfLink)`"
  type        = string
  default     = null
  validation {
    condition     = var.vpc_self_link != null || var.rc_firewall_tags != null
    error_message = "If manually created firewall tags are not provided, the vpc self link must be given to create firewall rules."
  }
}

variable "zone" {
  description = "(Optional) The zone the instances will be created in. If excluded, will select an available zone"
  type        = string
  default     = null
}

variable "dns_domain" {
  description = "(Optional) The domain name suffix of the DNS containing the DDM SRV discovery records. For example if the device SRV record is `default._dante-ddm-d._udp.my.domain.internal.` this should be `my.domain.internal.`"
  type        = string
  default     = null
}

variable "rc_firewall_tags" {
  description = "(Optional) The set of firewall tags which should be applied to the Remote Contributor instance. If excluded, firewall rules will be created automatically."
  type        = set(string)
  default     = null
}

variable "rc_image" {
  description = "(Optional) The image used to initialise the Remote Contributor instance. This image must have the MULTI_IP_SUBNET guest os feature. If excluded, a new custom ubuntu image will be created. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#image-1 for format"
  type        = string
  default     = null
}

variable "rc_version" {
  description = "(Optional) The version of Remote Contributor to be installed"
  type        = string
  default     = null
}
