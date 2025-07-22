<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante Linux multi-ip-subnet image

Terraform module to generate a custom image with the multi-ip-subnet guest OS feature. Generated from the latest Ubuntu 22.04 GCP image.

## Example Usage

```hcl
# This module
module "multi_ip_subnet_image" {
  source      = "github.com/Audinate/terraform-gcp-dante-connect//modules/common-modules/gce/dante-linux-image"
  environment = "test"
}

# Outputs the image name, which can be used in a Dante Gateway, Remote Monitor or Contributor
module "dante_gateway" {
  source        = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  machine_image = module.multi_ip_subnet_image.image_name
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
| [google_compute_image.multi_ip_subnet_image](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_image) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_compute_image.ubuntu](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_image) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | The ID of the project. Defaults to the provider project | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_image_name"></a> [image\_name](#output\_image\_name) | n/a |
<!-- END_TF_DOCS -->