#
# File : outputs.tf
# Created : June 2024
#
# Copyright 2024-2025 Audinate Pty Ltd and/or its licensors
#
#

output "dvs_network_tags" {
  value = setunion(
    google_compute_firewall.dvs_fw_allow_icmp.target_tags,
    google_compute_firewall.dvs_fw_allow_ssh.target_tags,
    google_compute_firewall.dvs_fw_allow_udp.target_tags,
    google_compute_firewall.dvs_fw_allow_rdp.target_tags
  )
}
