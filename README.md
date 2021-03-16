# NSX-T Manager Terraform Module

Terraform module which creates an NSX-T Manager virtual machine in a vSphere environment.

Presently, this module does not work with the official `terraform-provider-vsphere`. You must compile the provider from
[#1339](https://github.com/hashicorp/terraform-provider-vsphere/pull/1339).

The module presently assumes you are deploying from a machine with `bash` and `curl` installed.

The module has been tested with `nsx-unified-appliance-3.1.0.0.0.17107212-le.ova`.
Other versions may or may not work correctly.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| random | n/a |
| tls | n/a |
| vsphere | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [random_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) |
| [tls_certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) |
| [vsphere_ovf_vm_template](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/data-sources/ovf_vm_template) |
| [vsphere_virtual_machine](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/virtual_machine) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_username | The username of the NSX-T admin user. The default is "admin". | `string` | `"admin"` | no |
| audit\_username | The username of the NSX-T audit user. The default is "audit". | `string` | `"audit"` | no |
| cpu\_count\_override | The number of CPUs the NSX-t Manager Appliance should have. Defaults to 0 which uses the CPU count of the deployment selected. | `number` | `0` | no |
| datacenter\_id | The ID of the dataceter the NSX-T Manager Appliance should be created in. | `string` | n/a | yes |
| datastore\_id | The ID of the datastore the NSX-T Manager Appliance should be created in. | `string` | n/a | yes |
| deployment\_size | The deployment size of the NSX-T Manager Appliance. The default is "small" | `string` | `"small"` | no |
| dns | The DNS server for the NSX-T Manager Appliance. | `string` | n/a | yes |
| enable\_root\_ssh | Should root logins be permitted over SSH to the NSX-T Manager Appliance? | `bool` | `true` | no |
| enable\_ssh | Should SSH be enabled to the NSX-T Manager Appliance? | `bool` | `true` | no |
| folder\_name | The name of the vm folder the NSX-T Manager Appliance should be created in. | `string` | n/a | yes |
| gateway | The gateway of the NSX-T Manager Appliance. | `string` | n/a | yes |
| host\_system\_id | The ID of the host system that the NSX-T Manager Appliance OVA will be initially deployed on. | `string` | n/a | yes |
| hostname | The FQDN of the NSX-T Manager Appliance. DNS records must exist ahead of provisioning or DDNS must be working in the environment | `string` | n/a | yes |
| ip\_address | The IP address of the NSX-T Manager Appliance | `string` | n/a | yes |
| mac\_address | The MAC address of the NSX-T Manager Appliance. | `string` | n/a | yes |
| memory\_override | The ammount of memory the NSX-t Manager Appliance should have. Defaults to 0 which uses the memory size of the deployment selected. | `number` | `0` | no |
| netmask | The netmask of the nested ESXi hosts. | `string` | n/a | yes |
| network\_id | The ID of the network the NSX-T Manager Appliance should be attached to. | `string` | n/a | yes |
| ntp | The NTP server for the NSX-T Manager Appliance. | `string` | `"pool.ntp.org"` | no |
| ova\_path | The full path to the NSX-T Unified Appliance OVA. | `string` | n/a | yes |
| resource\_pool\_id | The ID of the resource pool the NSX-T Manager Appliance should be created in. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| admin\_password | The admin password generated for the NSX-T Manager |
| audit\_password | The audit password generated for the NSX-T Manager |
| root\_password | The root password generated for the NSX-T Manager |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->