<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante-WebRTC Endpoint

Terraform module which creates a parameterised instance of Remote Monitor/Contributor, potentially with an Application Load Balancer.
Not intended for external usage, see Remote Monitor or Contributor READMEs instead.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dante_webrtc_endpoint_base"></a> [dante\_webrtc\_endpoint\_base](#module\_dante\_webrtc\_endpoint\_base) | ../../gce/instance | n/a |
| <a name="module_dante_webrtc_endpoint_ddm_script"></a> [dante\_webrtc\_endpoint\_ddm\_script](#module\_dante\_webrtc\_endpoint\_ddm\_script) | ../../../configuration | n/a |
| <a name="module_lb"></a> [lb](#module\_lb) | ../../bridge/lb | n/a |

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.bridge_fw_allow_hc](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.bridge_fw_allow_lb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [cloudinit_config.user_data](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |
| [google_compute_subnetwork.target](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_subnetwork) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ephemeral_ip_address"></a> [associate\_public\_ephemeral\_ip\_address](#input\_associate\_public\_ephemeral\_ip\_address) | n/a | `bool` | `true` | no |
| <a name="input_associate_public_static_ip_address"></a> [associate\_public\_static\_ip\_address](#input\_associate\_public\_static\_ip\_address) | n/a | `bool` | `false` | no |
| <a name="input_audio_settings"></a> [audio\_settings](#input\_audio\_settings) | n/a | <pre>object({<br/>    rxChannels  = number<br/>    txChannels  = number<br/>    rxLatencyUs = number<br/>    txLatencyUs = number<br/>  })</pre> | n/a | yes |
| <a name="input_component_name_abbreviation"></a> [component\_name\_abbreviation](#input\_component\_name\_abbreviation) | n/a | `string` | n/a | yes |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | n/a | `bool` | `false` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | n/a | <pre>object({<br/>    hostname = optional(string, "")<br/>    ip       = string<br/>    port     = optional(string, "8000")<br/>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | n/a | <pre>object({<br/>    api_key      = string<br/>    api_host     = string<br/>    dante_domain = string<br/>  })</pre> | `null` | no |
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | n/a | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_firewall_tags"></a> [firewall\_tags](#input\_firewall\_tags) | n/a | `set(string)` | n/a | yes |
| <a name="input_installer_version"></a> [installer\_version](#input\_installer\_version) | n/a | `string` | n/a | yes |
| <a name="input_instance_network_tier"></a> [instance\_network\_tier](#input\_instance\_network\_tier) | n/a | `string` | `"STANDARD"` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | n/a | `string` | `null` | no |
| <a name="input_license_server"></a> [license\_server](#input\_license\_server) | n/a | <pre>object({<br/>    hostname = string<br/>    api_key  = string<br/>  })</pre> | <pre>{<br/>  "api_key": "638hPLfZd3nvZ4tXP",<br/>  "hostname": "https://software-license-danteconnect.svc.audinate.com"<br/>}</pre> | no |
| <a name="input_license_websocket_port"></a> [license\_websocket\_port](#input\_license\_websocket\_port) | License websocket port number | `number` | `49999` | no |
| <a name="input_machine_image"></a> [machine\_image](#input\_machine\_image) | n/a | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | File : variables.tf Created : November 2024 Authors : Synopsis:  Copyright 2024-2025 Audinate Pty Ltd and/or its licensors | `string` | `"n4-standard-4"` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | n/a | `string` | `null` | no |
| <a name="input_nic_type"></a> [nic\_type](#input\_nic\_type) | n/a | `string` | `"GVNIC"` | no |
| <a name="input_placement_policy"></a> [placement\_policy](#input\_placement\_policy) | n/a | `string` | `null` | no |
| <a name="input_product_identifiers"></a> [product\_identifiers](#input\_product\_identifiers) | Names of the product to use in automated scripts | <pre>object({<br/>    service_name         = string<br/>    product_name         = string<br/>    product_abbreviation = string <br/>  })</pre> | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | n/a | `string` | `null` | no |
| <a name="input_public_static_ip_network_tier"></a> [public\_static\_ip\_network\_tier](#input\_public\_static\_ip\_network\_tier) | n/a | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `null` | no |
| <a name="input_resource_url"></a> [resource\_url](#input\_resource\_url) | n/a | `string` | n/a | yes |
| <a name="input_ssl_certificate_self_links"></a> [ssl\_certificate\_self\_links](#input\_ssl\_certificate\_self\_links) | n/a | `list(string)` | `null` | no |
| <a name="input_stun_server_config"></a> [stun\_server\_config](#input\_stun\_server\_config) | n/a | `string` | `null` | no |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | n/a | `string` | n/a | yes |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | n/a | `number` | `null` | no |
| <a name="input_turn_server_config"></a> [turn\_server\_config](#input\_turn\_server\_config) | n/a | `list(string)` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | n/a | `number` | `null` | no |
| <a name="input_web_admin_account"></a> [web\_admin\_account](#input\_web\_admin\_account) | n/a | <pre>object({<br/>    email    = string<br/>    password = string<br/>  })</pre> | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_ip"></a> [lb\_ip](#output\_lb\_ip) | File : outputs.tf Created : November 2024 Authors : Synopsis:  Copyright 2024-2025 Audinate Pty Ltd and/or its licensors |
<!-- END_TF_DOCS -->