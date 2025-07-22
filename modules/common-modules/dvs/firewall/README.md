<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante Virtual Soundcard Firewall

Terraform module to generate firewall rules and tags for a Dante Gateway. Generates rules to allow Dante protocols and audio
from local devices, and ssh, RDP and ICMP access from the open internet.

## Example Usage

```hcl
# This module
module "dvs_firewall_rules" {
  source = "github.com/Audinate/terraform-gcp-dante-connect//modules/common-modules/dvs/firewall"
  environment = "test"
  network_self_link = "https://www.googleapis.com/compute/v1/projects/dante-prj/global/networks/vpc-network-0"
}

# Outputs the tags, which can be used in a Dante Gateway
module "dante_virtual_soundcard" {
  source                 = "github.com/Audinate/terraform-gcp-dante-connect//modules/virtual_soundcard"
  firewall_tags          = module.dvs_firewall_rules.dvs_network_tags
  # Other properties omitted for brevity
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
| [google_compute_firewall.dvs_fw_allow_icmp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.dvs_fw_allow_rdp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.dvs_fw_allow_ssh](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.dvs_fw_allow_udp](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_component_name_abbreviation"></a> [component\_name\_abbreviation](#input\_component\_name\_abbreviation) | The abbreviated name used for the given DVS | `string` | `"dvs"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_network_self_link"></a> [network\_self\_link](#input\_network\_self\_link) | The self\_link of the VPC network to associate the<br/>default firewall rules with. | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dvs_network_tags"></a> [dvs\_network\_tags](#output\_dvs\_network\_tags) | n/a |
<!-- END_TF_DOCS -->