#
# File : outputs.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

output "bridge_network_tags" {
  value = setunion(
    google_compute_firewall.bridge_fw_allow_udp.target_tags,
    google_compute_firewall.bridge_fw_allow_ext_ssh.target_tags,
    google_compute_firewall.bridge_fw_allow_icmp.target_tags
  )
}