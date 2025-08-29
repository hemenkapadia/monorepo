output "domain_id" {
  description = "The ID of the libvirt domain"
  value       = libvirt_domain.domain.id
}

output "domain_name" {
  description = "The name of the libvirt domain"
  value       = libvirt_domain.domain.name
}

output "mac_addresses" {
  description = "List of MAC addresses for the domain's NICs (order corresponds to network_interfaces)"
  value       = [for ni in libvirt_domain.domain.network_interface : try(ni.mac, null)]
}

output "ip_addresses" {
  description = "List of IP addresses reported for the domain's NICs (DHCP lease; may take time after create)"
  value       = [for ni in libvirt_domain.domain.network_interface : try(ni.addresses, null)]
}

output "cloudinit_attached" {
  description = "True if a cloudinit disk was attached"
  value       = local.cloudinit_id != null
}

output "cloudinit_disk_id" {
  description = "Cloudinit disk ID if attached (created or provided)"
  value       = local.cloudinit_id
}
