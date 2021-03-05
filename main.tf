locals {
  split_hostname = split(".", var.hostname)
  short_hostname = local.split_hostname[0]
  domain         = join(".", slice(local.split_hostname, 1, length(local.split_hostname)))
}

resource "random_password" "root_password" {
  length  = 16
  special = true
}

resource "random_password" "admin_password" {
  length  = 16
  special = true
}

resource "random_password" "audit_password" {
  length  = 16
  special = true
}

data "vsphere_ovf_vm_template" "ova" {
  name              = local.short_hostname
  folder            = var.folder_name
  resource_pool_id  = var.resource_pool_id
  datastore_id      = var.datastore_id
  host_system_id    = var.host_system_id
  local_ovf_path    = var.ova_path
  deployment_option = var.deployment_size
  ovf_network_map   = { "Network 1" : var.network_id }
  ip_protocol       = "IPv4"
  disk_provisioning = "thin"
}

resource "vsphere_virtual_machine" "nsxt_manager" {
  name             = data.vsphere_ovf_vm_template.ova.name
  datacenter_id    = var.datacenter_id
  folder           = data.vsphere_ovf_vm_template.ova.folder
  resource_pool_id = data.vsphere_ovf_vm_template.ova.resource_pool_id
  host_system_id   = data.vsphere_ovf_vm_template.ova.host_system_id
  datastore_id     = data.vsphere_ovf_vm_template.ova.datastore_id

  num_cpus               = var.cpu_count_override > 0 ? var.cpu_count_override : data.vsphere_ovf_vm_template.ova.num_cpus
  num_cores_per_socket   = data.vsphere_ovf_vm_template.ova.num_cores_per_socket
  cpu_hot_add_enabled    = data.vsphere_ovf_vm_template.ova.cpu_hot_add_enabled
  cpu_hot_remove_enabled = data.vsphere_ovf_vm_template.ova.cpu_hot_remove_enabled
  nested_hv_enabled      = data.vsphere_ovf_vm_template.ova.nested_hv_enabled
  memory                 = var.memory_override > 0 ? var.memory_override : data.vsphere_ovf_vm_template.ova.memory
  memory_hot_add_enabled = data.vsphere_ovf_vm_template.ova.memory_hot_add_enabled
  //swap_placement_policy  = data.vsphere_ovf_vm_template.ova.swap_placement_policy
  annotation           = data.vsphere_ovf_vm_template.ova.annotation
  guest_id             = data.vsphere_ovf_vm_template.ova.guest_id
  alternate_guest_name = data.vsphere_ovf_vm_template.ova.alternate_guest_name
  //firmware               = data.vsphere_ovf_vm_template.ova.firmware

  enable_logging = true
  scsi_type      = "lsilogic"

  network_interface {
    network_id     = var.network_id
    use_static_mac = var.mac_address == "" ? false : true
    mac_address    = var.mac_address
  }

  ovf_deploy {
    local_ovf_path    = data.vsphere_ovf_vm_template.ova.local_ovf_path
    disk_provisioning = data.vsphere_ovf_vm_template.ova.disk_provisioning
    ip_protocol       = data.vsphere_ovf_vm_template.ova.ip_protocol
    ovf_network_map   = data.vsphere_ovf_vm_template.ova.ovf_network_map
    deployment_option = data.vsphere_ovf_vm_template.ova.deployment_option
  }

  vapp {
    properties = {
      "nsx_passwd_0"           = random_password.root_password.result
      "nsx_cli_passwd_0"       = random_password.admin_password.result
      "nsx_cli_audit_passwd_0" = random_password.audit_password.result
      "nsx_cli_username"       = var.admin_username
      "nsx_cli_audit_username" = var.audit_username
      "nsx_hostname"           = var.hostname
      "nsx_role"               = "NSX Manager"
      "nsx_gateway_0"          = var.gateway
      "nsx_ip_0"               = var.ip_address
      "nsx_netmask_0"          = var.netmask
      "nsx_dns1_0"             = var.dns
      "nsx_domain_0"           = local.domain
      "nsx_ntp_0"              = var.ntp
      "nsx_isSSHEnabled"       = title(tostring(var.enable_ssh))
      "nsx_allowSSHRootLogin"  = title(tostring(var.enable_root_ssh))
    }
  }

  lifecycle {
    ignore_changes = [
      // it looks like some of the properties get deleted from the VM after it is deployed
      // just ignore them after the initial deployment
      vapp.0.properties,
    ]
  }
}

data "tls_certificate" "nsxt_manager_certificate" {
  url          = "https://${var.hostname}"
  verify_chain = false

  depends_on = [
    vsphere_virtual_machine.nsxt_manager,
  ]
}
