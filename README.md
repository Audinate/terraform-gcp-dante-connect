<!-- Copyright 2024-2025 Audinate Pty Ltd and/or its licensors -->

## Modules

A collection of Terraform modules to create instances of selected Dante Connect components:

* [Dante Gateway](modules/gateway)
* [Dante Virtual Soundcard](modules/virtual-soundcard)
* [Remote Monitor](modules/remote-monitor)
* [Remote Contributor](modules/remote-contributor)

### Utility Modules

A collection of utility modules for creating infrastructure shared between instances.

* [Dante Linux Image](modules/common-modules/gce/dante-linux-image)
* [Dante Virtual Soundcard Firewall](modules/common-modules/dvs/firewall)
* [Dante Gateway Firewall](modules/common-modules/dgw/firewall)
* [Dante WebRTC Endpoint Firewall](modules/common-modules/bridge/firewall)

## Examples

Examples for licensing and DDM enrollment

* [Discovered DDM Setup](examples/discovered-ddm-setup/)
* [Static DDM Setup](examples/static-ddm-setup/)
* [Auto Enrollment in Discovered DDM](examples/auto-enrollment-in-discovered-ddm/)
* [Low Latency Instance Group in Discovered DDM](examples/low-latency-setup/)
* [Remote Monitor with Application Load Balancer](examples/remote-monitor-with-alb)
* [Remote Contributor with Application Load Balancer](examples/remote-contributor-with-alb)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.8.3 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 5.28.0 |

## Bug Reports & Feature Requests
Please use the [issue tracker](https://github.com/Audinate/terraform-gcp-dante-connect/issues) to report any bugs or file feature requests for Dante Connect Terraform scripts.

## Support
Support enquiries may be lodged via the Audinate website https://www.audinate.com/contact/support or via email to support@audinate.com.

## Copyright
Copyright 2024-2025 Audinate Pty Ltd and/or its licensors

## License
[Mozilla Public License v2.0](./LICENSE)
