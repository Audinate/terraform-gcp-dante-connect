<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante WebRTC Endpoint Firewall

Terraform module to generate firewall rules and tags for a Remote Monitor/Contributor. Generates rules to allow Dante protocols and audio
from local devices, and ssh and ICMP access from the open internet.

Note that the rules for HTTP ingress from the load balancer are dependent on the load balancer itself, so are managed by the Remote Monitor/Contributor module

## Example Usage

```hcl
# This module
module "rm_firewall_rules" {
  source = "github.com/Audinate/terraform-gcp-dante-connect//modules/common-modules/bridge/firewall"
  environment = "test"
  network_self_link = "https://www.googleapis.com/compute/v1/projects/dante-prj/global/networks/vpc-network-0"
  component_name_abbreviation = "rm"
}

# Outputs the tags, which can be used in a Remote Monitor or Contributor
module "remote_monitor" {
  source                     = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  firewall_tags              = module.rm_firewall_rules.bridge_network_tags
  # Other properties excluded for brevity
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.28.0 |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.bridge_fw_allow_ext_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.bridge_fw_allow_icmp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.bridge_fw_allow_udp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component_name_abbreviation"></a> [component\_name\_abbreviation](#input\_component\_name\_abbreviation) | The abbreviated name used for the given Dante WebRTC Endpoint. | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment. | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | The self\_link of the VPC network to associate the firewall rules with. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bridge_network_tags"></a> [bridge\_network\_tags](#output\_bridge\_network\_tags) | n/a |
<!-- END_TF_DOCS -->