#
# File : output.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

output "dgw_network_tags" {
  value = setunion(
    google_compute_firewall.dgw_fw_allow_icmp.target_tags,
    google_compute_firewall.dgw_fw_allow_ssh.target_tags,
    google_compute_firewall.dgw_fw_allow_udp.target_tags
  )
}
