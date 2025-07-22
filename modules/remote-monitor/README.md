<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

# Remote Monitor

Terraform module, which creates instances of the Remote Monitor.

## Example Usage

Remote Monitor should be run on an instance with the MULTI_IP_SUBNET guest os feature. See the documentation for more details.

### Remote Monitor with fresh installation

Creates an instance with a fresh installation of the Remote Monitor.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "rm-icmp-allow"]
  web_admin_account           = {
    mail    = "some-email@some.com"
    password = "admin123"
  }
}
```
### Remote Monitor with static DDM addressing by IP and port

Creates an instance of the Remote Monitor component which references the Dante Domain Manager by IP and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "rm-icmp-allow"]
  ddm_address                 = {
    ip      = "10.0.1.123"
    port    = "8000"
  }
  web_admin_account           = {
    mail    = "some-email@some.com"
    password = "admin123"
  }
}
```

### Remote Monitor with static DDM addressing by hostname and port

Creates an instance of the Remote Monitor component which references the Dante Domain Manager by hostname and port.
Static addressing must be configured in case the DDM discovery is not set up.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "rm-icmp-allow"]
  ddm_address                 = {
    hostname = "vm-ddm-test.c.test-project-name.internal"
    ip       = "10.0.1.123"
    port     = "8000"
  }
  web_admin_account           = {
    mail     = "some-email@some.com"
    password = "admin123"
  }
}
```

### Remote Monitor with DDM configuration for auto-enrollment

Creates an instance of the Remote Monitor component which auto-enrolls in the provided Dante domain.

#### Prerequisites

Note that this feature uses bash scripts run locally, i.e. on the same machine as terraform is running. As such this feature can only be used on Linux or MacOS, or in a Linux-like environment on Windows (such as WSL, Cygwin or MinGW). You will need to install the [`jq` package](https://jqlang.github.io/jq/) in your environment. It is available through most package managers.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "rm-icmp-allow"]
  ddm_configuration           = {
    api_key      = "404c1e8f-c263-4d78-9920-1268f42aadb8"
    api_host     = "https://<public_ip_ddm or public_domain_ddm>:4000/graphql"
    dante_domain = "tf-test"
  }
  web_admin_account           = {
    mail        = "some-email@some.com"
    password    = "admin123"
  }
}
```

### Remote Monitor with custom audio settings

Creates an instance of the Remote Monitor component with customised audio settings.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  audio_settings = {
    rxChannels  = 16
    rxLatencyUs = 100000
  }
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "rm-icmp-allow"]
  web_admin_account           = {
    mail     = "some-email@some.com"
    password = "admin123"
  }
}
```

### Remote Monitor with stun/turn server configuration

Creates an instance of the Remote Monitor component with customised stun/turn server configuration.

```hcl
module "remote_monitor" {
  source                      = "github.com/Audinate/terraform-gcp-dante-connect//modules/remote-monitor"
  environment                 = "test"
  machine_image               = "my-project/multi-ip-subnet-custom-image"
  subnet_self_link            = "https://www.googleapis.com/compute/v1/projects/dante-prj/regions/europe-west4/subnetworks/sn-private-test-0"
  turn_server_config          = ["turn:<username>:<password>@<host>:<port>?transport=<tcp|udp|tls>"]
  stun_server_config          = "stun:a.relay.metered.ca:80"
  # firewall roles have to be created before to be able to use proper network tags for Remote Monitor instance
  firewall_tags               = ["rm-udp-allow", "rm-ssh-allow", "other-rm-allow"]
  web_admin_account           = {
    mail     = "some-email@some.com"
    password = "admin123"
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
| <a name="module_remote_monitor"></a> [remote\_monitor](#module\_remote\_monitor) | ../common-modules/bridge/dante-webrtc-endpoint | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_associate_public_ephemeral_ip_address"></a> [associate\_public\_ephemeral\_ip\_address](#input\_associate\_public\_ephemeral\_ip\_address) | Should create a public ephemeral IP. Either `associate_public_ephemeral_ip_address` or<br/>`associate_public_static_ip_address` should be true in case you do not use a TURN server. | `bool` | `true` | no |
| <a name="input_associate_public_static_ip_address"></a> [associate\_public\_static\_ip\_address](#input\_associate\_public\_static\_ip\_address) | Should create a public static IP. Either `associate_public_ephemeral_ip_address` or<br/>`associate_public_static_ip_address` should be true in case you do not use a TURN server. | `bool` | `false` | no |
| <a name="input_audio_settings"></a> [audio\_settings](#input\_audio\_settings) | (Optional) the audio settings in the following format:<br/>audio\_settings = {<br/>  rxChannels  = "The number of RX channels"<br/>  rxLatencyUs = "Asymmetric latency for RX in microseconds"<br/>} | <pre>object({<br/>    rxChannels  = number<br/>    rxLatencyUs = number<br/>  })</pre> | `null` | no |
| <a name="input_component_name_abbreviation"></a> [component\_name\_abbreviation](#input\_component\_name\_abbreviation) | (Optional) The abbreviated name used for the given Remote Monitor. | `string` | `"rm"` | no |
| <a name="input_create_lb"></a> [create\_lb](#input\_create\_lb) | (Optional) If true, a load balancer in front of the Remote Monitor (to perform HTTPS termination) and required<br/>firewall rules will be created. | `bool` | `false` | no |
| <a name="input_ddm_address"></a> [ddm\_address](#input\_ddm\_address) | (Optional) Must be provided in case DDM DNS Discovery is not set-up.<br/>If provided, the ip is required, the hostname and port are optional.<br/>If the hostname is provided, it will be used by supported Dante devices to contact the DDM in case of IP change.<br/>ddm\_address = {<br/>  hostname = "The hostname of the DDM"<br/>  ip    = "The IPv4 of the DDM"<br/>  port  = "The port of the DDM"<br/>} | <pre>object({<br/>    hostname = optional(string, "")<br/>    ip       = string<br/>    port     = optional(string, "8000")<br/>  })</pre> | `null` | no |
| <a name="input_ddm_configuration"></a> [ddm\_configuration](#input\_ddm\_configuration) | (Optional) When the DDM configuration is passed, the created node will automatically be enrolled into the dante domain<br/>and configured for unicast clocking. This requires the local environment to be Unix or a Linux-like environment on Windows (such as WSL, Cygwin or MinGW)<br/>ddm\_configuration = {<br/>  api\_key      = "The API key to use while performing the configuration"<br/>  api\_host     = "The full name (including protocol, host, port and path) of the location of DDM API"<br/>  dante\_domain = "The dante domain to use, must be pre-provisioned"<br/>} | <pre>object({<br/>    api_key      = string<br/>    api_host     = string<br/>    dante_domain = string<br/>  })</pre> | `null` | no |
| <a name="input_dns_domain"></a> [dns\_domain](#input\_dns\_domain) | (Optional) The DNS domain name which is used for the DDM. Required for DDM DNS Discovery. | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The name of the environment | `string` | n/a | yes |
| <a name="input_firewall_tags"></a> [firewall\_tags](#input\_firewall\_tags) | A list of firewall tags the Remote Monitor instance will be associated with. | `set(string)` | n/a | yes |
| <a name="input_installer_version"></a> [installer\_version](#input\_installer\_version) | (Optional) The version of the Remote Monitor to be installed | `string` | `"1.0.1.3"` | no |
| <a name="input_instance_network_tier"></a> [instance\_network\_tier](#input\_instance\_network\_tier) | (Optional) The networking tier used for configuring this instance. This field can take the following values:<br/>PREMIUM, FIXED\_STANDARD or STANDARD. | `string` | `"STANDARD"` | no |
| <a name="input_license_key"></a> [license\_key](#input\_license\_key) | (Optional) The Remote Monitor license provided by Audinate | `string` | `null` | no |
| <a name="input_license_server"></a> [license\_server](#input\_license\_server) | (Optional) License settings<br/>license\_server = {<br/>  hostname    = "License server hostname"<br/>  api\_key     = "License server api key"<br/>} | <pre>object({<br/>    hostname = string<br/>    api_key  = string<br/>  })</pre> | <pre>{<br/>  "api_key": "638hPLfZd3nvZ4tXP",<br/>  "hostname": "https://software-license-danteconnect.svc.audinate.com"<br/>}</pre> | no |
| <a name="input_license_websocket_port"></a> [license\_websocket\_port](#input\_license\_websocket\_port) | (Optional) License websocket port number | `number` | `49999` | no |
| <a name="input_machine_image"></a> [machine\_image](#input\_machine\_image) | The image to use for the instance. | `string` | n/a | yes |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | (Optional) The machine type to use for the instance. Updates to this field will trigger a stop/start of the instance. | `string` | `"n4-standard-4"` | no |
| <a name="input_maintenance_policy"></a> [maintenance\_policy](#input\_maintenance\_policy) | (Optional) Describes maintenance behavior for the instance. Defaults to MIGRATE.<br/>Can be MIGRATE or TERMINATE, for more info, read https://cloud.google.com/compute/docs/instances/setting-instance-scheduling-options. | `string` | `null` | no |
| <a name="input_nic_type"></a> [nic\_type](#input\_nic\_type) | (Optional) The type of vNIC to be used on this interface. Possible values: GVNIC, VIRTIO\_NET. | `string` | `"GVNIC"` | no |
| <a name="input_placement_policy"></a> [placement\_policy](#input\_placement\_policy) | The self\_link of the placement policy to attach to the instance. Compact placement policies can be used to improve<br/>latency. Note that compact placement can be used only with certain machine types. | `string` | `null` | no |
| <a name="input_project"></a> [project](#input\_project) | (Optional) The ID of the project in which the resource belongs. If it is not provided, the provider project is used. | `string` | `null` | no |
| <a name="input_public_static_ip_network_tier"></a> [public\_static\_ip\_network\_tier](#input\_public\_static\_ip\_network\_tier) | (Optional) Applicable only if `associate_public_static_ip_address` is true. The networking tier used for configuring the public<br/>static IP address. Possible values are: PREMIUM, STANDARD. | `string` | `null` | no |
| <a name="input_region"></a> [region](#input\_region) | (Optional) The Region in which the created addresses should reside. If it is not provided, the provider region is used. | `string` | `null` | no |
| <a name="input_resource_url"></a> [resource\_url](#input\_resource\_url) | (Optional) The url to download a remote-monitor installer | `string` | `"https://audinate-dante-connect.sgp1.cdn.digitaloceanspaces.com/remote-monitor"` | no |
| <a name="input_ssl_certificate_self_links"></a> [ssl\_certificate\_self\_links](#input\_ssl\_certificate\_self\_links) | (Optional) Required when create\_lb is true. Self links to SSL certificates to associate with the load balancer. | `list(string)` | `null` | no |
| <a name="input_stun_server_config"></a> [stun\_server\_config](#input\_stun\_server\_config) | (Optional) Stun server configuration provided ex. stun.l.google.com:19302 | `string` | `null` | no |
| <a name="input_subnet_self_link"></a> [subnet\_self\_link](#input\_subnet\_self\_link) | The VPC Subnet the instance's network interface will be associated with. | `string` | n/a | yes |
| <a name="input_timeout_sec"></a> [timeout\_sec](#input\_timeout\_sec) | (Optional) Timeout of the request from the load balancer to the Remote Monitor. Default is 30 seconds. Valid range is [1, 86400]. | `number` | `null` | no |
| <a name="input_turn_server_config"></a> [turn\_server\_config](#input\_turn\_server\_config) | (Optional) Turn server configuration provided ex. [turn:<username>:<password>@<host>:<port>?transport=<tcp\|udp\|tls>, ...] | `list(string)` | `null` | no |
| <a name="input_volume_size"></a> [volume\_size](#input\_volume\_size) | (Optional) Size of the volume in gigabytes. | `number` | `null` | no |
| <a name="input_web_admin_account"></a> [web\_admin\_account](#input\_web\_admin\_account) | The account information to log in to Remote Monitor for web administration<br/>web\_admin\_account = {<br/>  email      = "Admin email address"<br/>  password   = "Admin password"<br/>} | <pre>object({<br/>    email    = string<br/>    password = string<br/>  })</pre> | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | (Optional) The zone that the machine should be created in. If it is not provided, the provider zone is used. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_lb_ip"></a> [lb\_ip](#output\_lb\_ip) | The external ip of the load balancer which forwards to the Remote Monitor. Null if the LB was not created |
<!-- END_TF_DOCS -->
