# NSX-T Manager Terraform Module

Terraform module which creates an NSX-T Manager virtual machine in a vSphere environment.

Presently, this module does not work with the official `terraform-provider-vsphere`. You must compile the provider from
[#1339](https://github.com/hashicorp/terraform-provider-vsphere/pull/1339).

The module presently assumes you are deploying from a machine with `bash` and `curl` installed.

The module has been tested with `nsx-unified-appliance-3.1.0.0.0.17107212-le.ova`.
Other versions may or may not work correctly.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->