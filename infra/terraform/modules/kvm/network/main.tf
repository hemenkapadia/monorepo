# Network
resource "libvirt_network" "network" {
  name      = var.network_name
  domain    = var.network_domain
  addresses = var.network_address_cidr
  mode      = var.network_mode
  autostart = var.network_autostart
  dns {
    enabled    = var.network_dns_enabled
    local_only = var.network_dns_local_only

    # Add host entries
    dynamic "hosts" {
      for_each = var.network_dns_hosts
      content {
        ip       = host.value.ip
        hostname = host.value.hostname
      }
    }

    # Add forwarders
    dynamic "forwarders" {
      for_each = var.network_dns_forwarders
      content {
        domain  = try(forwarder.value.domain, null)
        address = forwarder.value.addr
      }
    }
  }
}
