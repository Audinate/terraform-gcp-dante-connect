<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Dante Gateway

Terraform module, which creates instances of the Dante Gateway.

## Example Usage

Dante Gateway should be run on an instance with the MULTI_IP_SUBNET guest os feature. See the documentation for more details.

### DGW with fresh installation

Creates an instance with a fresh installation of the Dante Gateway.
By default it uses n4-standard-4 machine type. When available, it is a good decision to place a deployment in a placement group, but in some zones / instance types it can be unavailable, in case of issues please check https://cloud.google.com/compute/docs/regions-zones or https://cloud.google.com/compute/docs/instances/placement-policies-overview

```hcl
module "dgw" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Dante Gateway instance
  firewall_tags               = ["dgw-udp-allow", "dgw-ssh-allow", "other-dgw-allow"]
}
```


### DGW with static DDM addressing by IP and port

Creates an instance of the Dante Gateway which references the Dante Domain Manager by IP and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dgw" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Dante Gateway instance
  firewall_tags               = ["dgw-udp-allow", "dgw-ssh-allow", "other-dgw-allow"]
  ddm_address = {
    ip   = "10.0.1.123"
    port = "8000"
  }
}
```


### DGW with static DDM addressing by hostname and port

Creates an instance of the Dante Gateway which references the Dante Domain Manager by hostname and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "dgw" {
  source      = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Dante Gateway instance
  firewall_tags               = ["dgw-udp-allow", "dgw-ssh-allow", "other-dgw-allow"]
  ddm_address = {
    hostname = "vm-ddm-test.c.test-project-name.internal"
    ip       = "10.0.1.123"
    port     = "8000"
  }
}
```


### DGW with DDM configuration for auto-enrollment

Creates an instance of the Dante Gateway which auto-enrolls in the provided Dante domain.

#### Prerequisites

Note that this feature uses bash scripts run locally, i.e. on the same machine as terraform is running. As such this feature can only be used on Linux or MacOS, or in a Linux-like environment on Windows (such as WSL, Cygwin or MinGW). You will need to install the [`jq` package](https://jqlang.github.io/jq/) in your environment. It is available through most package managers.

```hcl
module "dgw" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Dante Gateway instance
  firewall_tags               = ["dgw-udp-allow", "dgw-ssh-allow", "other-dgw-allow"]
  ddm_configuration           = {
    api_key      = "404c1e8f-c263-4d78-9920-1268f42aadb8"
    api_host     = "https://<public_ip_ddm or public_domain_ddm>:4000/graphql"
    dante_domain = "tf-test"
  }
}
```

### DGW with custom audio settings

Creates an instance of the Dante Gateway with customised audio settings.

```hcl
module "dgw" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/gateway"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Dante Gateway instance
  resource_url                = "https://some-link-test.s3.ap-southeast-2.amazonaws.com/share/dgw
  audio_settings              = {
    txChannels  = 64
    rxChannels  = 64
    txLatencyUs = 10000
    rxLatencyUs = 100000
  }
}
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.28.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_dgw"></a> [dgw](#module\_dgw) | ../common-modules/gce/instance | n/a |
| <a name="module_dgw_ddm_script"></a> [dgw\_ddm\_script](#module\_dgw\_ddm\_script) | ../configuration | n/a |

## Resources

| Name | Type |
|------|------|
| [random_id.random](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [cloudinit_config.startup_script](https://registry.terraform.io/providers/hashicorp/cloudinit/latest/docs/data-sources/config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_audio_settings"></a> [audio\_settings](#input\_audio\_settings) | (Optional) the audio settings in the following format:<br/>audio\_settings = {<br/>  txChannels  = "The number of TX channels"<br/>  rxChannels  = "The number of RX channels"<br/>  txLatencyUs = "Asymmetric latency for TX in microseconds"<br/>  rxLatencyUs = "Asymmetric latency for RX in microseconds"<br/>} | <pre>object({<br/>    txChannels  = number<br/>    rxChannels  = number<br/>    txLatencyUs = number<br/>    rxLatencyUs = number<br/>  })</pre> | `null` | no |
| <a name="input_component_name_abbreviation"></a> [component\_name\_abbreviation](#input\_component\_name\_abbreviation) | (Optional) The abbreviated name used for the given DGW | `string` | `"dgw"` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | (Optional) Must be provided in case DDM DNS Discovery is not set-up.<br/>If provided, the ip is required, the port defaults to 8000 and the hostname is optional.<br/>If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.<br/>ddm\_address = {<br/>  hostname = "The hostname of the DDM"<br/>  ip    = "The IPv4 of the DDM"<br/>  port  = "The port of the DDM"<br/>} | <pre>object({<br/>    hostname = optional(string, "")<br/>    ip       = string<br/>    port     = optional(string, "8000")<br/>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain<br/>and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)<br/>ddm\_configuration = {<br/>  api\_key      = "The API key to use while performing the configuration"<br/>  api\_host     = "The full name (including protocol, host, port and path) of the location of DDM API"<br/>  dante\_domain = "The dante domain to use, must be pre-provisioned"<br/>} | <pre>object({<br/>    api_key      = string<br/>    api_host     = string<br/>    dante_domain = string<br/>  })</pre> | `null` | no |
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | (Optional) The DNS domain name which is used for the DDM. This must match the DNS domain name as of which the<br/>`managed_zone_name` is provided. When both domain and managed\_zone\_name are provided required records are written for<br/>DDM auto discovery. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_firewall_tags"></a> [firewall\_tags](#input\_firewall\_tags) | A list of firewall tags the Gateway instance will be associated with. | `set(string)` | n/a | yes |
| <a name="input_installer_version"></a> [installer\_version](#input\_installer\_version) | (Optional) The version of the DGW to be installed | `string` | `"1.1.1.1"` | no |
| <a name="input_instance_network_tier"></a> [instance\_network\_tier](#input\_instance\_network\_tier) | (Optional) The networking tier used for configuring this instance. This field can take the following values:<br/>PREMIUM, FIXED\_STANDARD or STANDARD. | `string` | `"STANDARD"` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | (Optional) The DGW license provided by Audinate | `string` | `null` | no |
| <a name="input_license_server"></a> [license\_server](#input\_license\_server) | (Optional) License settings<br/>"license\_server" = {<br/>  hostname      = "License server hostname"<br/>  api\_key     = "License server api key"<br/>} | <pre>object({<br/>    hostname = string<br/>    api_key  = string<br/>  })</pre> | <pre>{<br/>  "api_key": "638hPLfZd3nvZ4tXP",<br/>  "hostname": "https://software-license-danteconnect.svc.audinate.com"<br/>}</pre> | no |
| <a name="input_license_websocket_port"></a> [license\_websocket\_port](#input\_license\_websocket\_port) | (Optional) License websocket port number | `number` | `49999` | no |
| <a name="input_licensed_channel_count"></a> [licensed\_channel\_count](#input\_licensed\_channel\_count) | (Optional) The number of licensed channels | `number` | `null` | no |
| <a name="input_machine_image"></a> [machine\_image](#input\_machine\_image) | The image to use for the instance. | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | (Optional) The machine type to use for the instance. Updates to this field will trigger a stop/start of the instance. | `string` | `"n4-standard-4"` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | (Optional) Describes maintenance behavior for the instance. Defaults to MIGRATE.<br/>Can be MIGRATE or TERMINATE, for more info, read https://cloud.google.com/compute/docs/instances/setting-instance-scheduling-options. | `string` | `null` | no |
| <a name="input_nic_type"></a> [nic\_type](#input\_nic\_type) | (Optional) The type of vNIC to be used on this interface. Possible values: GVNIC, VIRTIO\_NET. | `string` | `"GVNIC"` | no |
| <a name="input_placement_policy"></a> [placement\_policy](#input\_placement\_policy) | (Optional) The self\_link of the placement policy to attach to the instance. Compact placement policies can be used to improve<br/>latency. Note that compact placement can be used only with certain machine types. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_public_static_ip_network_tier"></a> [public\_static\_ip\_network\_tier](#input\_public\_static\_ip\_network\_tier) | (Optional) The networking tier used for configuring the public static IP address of the instance. Possible values are: PREMIUM, STANDARD. | `string` | `"STANDARD"` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The Region in which the created addresses should reside. If it is not provided, the provider region is used. | `string` | `null` | no |
| <a name="input_resource_url"></a> [resource\_url](#input\_resource\_url) | (Optional) The url to download a DGW installer | `string` | `"https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/dgw"` | no |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | The VPC Subnet the instance's network interface will be associated with. | `string` | n/a | yes |
| <a name="input_user_ssh_keys"></a> [user\_ssh\_keys](#input\_user\_ssh\_keys) | (Optional) Map of usernames to their SSH public key paths to be able to ssh instance | <pre>list(object({<br/>    user     = string<br/>    key_path = string<br/>  }))</pre> | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Optional) Size of the volume in gigabytes. | `number` | `50` | no |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) The zone that the machine should be created in. If it is not provided, the provider zone is used. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dgw_instance_name"></a> [dgw\_instance\_name](#output\_dgw\_instance\_name) | Name of Dante Gateway Compute instance |
| <a name="output_dgw_private_ip"></a> [dgw\_private\_ip](#output\_dgw\_private\_ip) | Private IP of the Dante Gateway instance |
<!-- END_TF_DOCS -->
