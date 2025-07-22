<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Auto Licensing Example with DDM Discovery

This example illustrates how to create instances of Dante Virtual Soundcard and Dante Gateway for Dante Connect.
If DDM discovery records are set up, the dns_domain variable can be provided to have devices discover DDM after starting up.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dgw_64"></a> [dgw\_64](#module\_dgw\_64) | ../../modules/gateway | n/a |
| <a name="module_dgw_fw_rules"></a> [dgw\_fw\_rules](#module\_dgw\_fw\_rules) | ../../modules/common-modules/dgw/firewall | n/a |
| <a name="module_dgw_image"></a> [dgw\_image](#module\_dgw\_image) | ../../modules/common-modules/gce/dante-linux-image | n/a |
| <a name="module_dvs_256"></a> [dvs\_256](#module\_dvs\_256) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_64"></a> [dvs\_64](#module\_dvs\_64) | ../../modules/virtual-soundcard | n/a |
| <a name="module_dvs_fw_rules"></a> [dvs\_fw\_rules](#module\_dvs\_fw\_rules) | ../../modules/common-modules/dvs/firewall | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_zones.available](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dgw_firewall_tags"></a> [dgw\_firewall\_tags](#input\_dgw\_firewall\_tags) | (Optional) The set of firewall tags which should be applied to the Dante Gateway instances. If excluded, firewall rules will be created automatically. | `set(string)` | `null` | no |
| <a name="input_dgw_image"></a> [dgw\_image](#input\_dgw\_image) | (Optional) The image used to initialise the Dante Gateway instances. This image must have the MULTI\_IP\_SUBNET guest os feature. If excluded, a new custom ubuntu image will be created. See https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_instance#image-1 for format | `string` | `null` | no |
| <a name="input_dgw_version"></a> [dgw\_version](#input\_dgw\_version) | (Optional) The version of Dante Gateway to be installed | `string` | `null` | no |
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | (Optional) The domain name suffix of the DNS containing the DDM SRV discovery records. For example if the device SRV record is `default._dante-ddm-d._udp.my.domain.internal.` this should be `my.domain.internal.` | `string` | `null` | no |
| <a name="input_dvs_firewall_tags"></a> [dvs\_firewall\_tags](#input\_dvs\_firewall\_tags) | (Optional) The set of firewall tags which should be applied to the DVS instances. If excluded, firewall rules will be created automatically. | `set(string)` | `null` | no |
| <a name="input_dvs_version"></a> [dvs\_version](#input\_dvs\_version) | (Optional) The version of DVS to be installed | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | The project ID of the GCP project the instances will be created in | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region the instances will be created in | `string` | n/a | yes |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | The subnet this instance will be associated with. The subnet's self link can be determined by running `gcloud compute networks subnets describe <subnet_name> --region=<region_name> --format='default(selfLink)'` | `string` | n/a | yes |
| <a name="input_vpc_self_link"></a> [vpc\_self\_link](#input\_vpc\_self\_link) | (Optional) The vpc for instance firewall rules to be created in. The VPC self link can be determined by running `gcloud compute networks describe <vpc_name> --format='default(selfLink)` | `string` | `null` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) The zone the instances will be created in. If excluded, will select an available zone | `string` | `null` | no |
<!-- END_TF_DOCS -->
