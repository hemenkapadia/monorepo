# Network
resource "libvirt_network" "network" {
  lifecycle {
    precondition {
      condition     = var.network_mode != "bridge" || var.network_bridge_interface_name != null
      error_message = "network_bridge is required when network_mode is 'bridge'"
    }
    precondition {
      condition = var.network_mode != "nat" || (
        var.network_nat_gateway_ip != null &&
        var.network_nat_netmask != null &&
        var.network_nat_dhcp_range_start != null &&
        var.network_nat_dhcp_range_end != null
      )
      error_message = "network_nat_gateway_ip, network_nat_netmask, network_nat_dhcp_range_start, and network_nat_dhcp_range_end are required when network_mode is 'nat'"
    }
  }

  name      = var.network_name
  autostart = var.network_autostart
  ipv6      = "no"
  bridge = (var.network_mode == "bridge" && var.network_bridge_interface_name != null) ? {
    name = var.network_bridge_interface_name
  } : null
  forward = {
    mode = var.network_mode
  }
  domain = var.network_mode != "bridge" ? {
    name       = var.network_domain
    local_only = var.network_domain_local_only ? "yes" : "no"
  } : null
  dns = (var.network_mode != "bridge" && var.network_dns_enabled) ? {
    enabled             = "yes"
    forward_plain_names = var.network_dns_forward_plain_names ? "yes" : "no"
    forwarders          = var.network_dns_forwarders
    host                = var.network_dns_host
  } : null
  ips = var.network_mode == "nat" ? [{
    address = var.network_nat_gateway_ip
    netmask = var.network_nat_netmask
    dhcp = {
      ranges = [
        {
          start = var.network_nat_dhcp_range_start
          end   = var.network_nat_dhcp_range_end
        }
      ]
      hosts = var.network_nat_dhcp_hosts
    }
  }] : []
}
