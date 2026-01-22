# Network
resource "libvirt_network" "network" {
  lifecycle {
    precondition {
      condition     = var.network_mode != "bridge" || var.network_bridge != null
      error_message = "network_bridge is required when network_mode is 'bridge'"
    }
    precondition {
      condition     = var.network_mode != "nat" || length(var.network_address_cidr) > 0
      error_message = "network_address_cidr is required when network_mode is 'nat'"
    }
  }

  name      = var.network_name
  domain    = var.network_mode == "bridge" ? null : var.network_domain
  addresses = var.network_mode == "bridge" ? [] : var.network_address_cidr
  mode      = var.network_mode
  bridge    = var.network_mode == "bridge" ? var.network_bridge : null
  autostart = var.network_autostart

  # DHCP configuration (only for NAT mode)
  dynamic "dhcp" {
    for_each = var.network_mode == "bridge" ? [] : [1]
    content {
      enabled = var.network_dhcp_enabled
    }
  }

  # DNS configuration (only for NAT mode)
  dynamic "dns" {
    for_each = var.network_mode == "bridge" ? [] : [1]
    content {
      enabled    = var.network_dns_enabled
      local_only = var.network_dns_local_only

      # Add host entries
      dynamic "hosts" {
        for_each = var.network_dns_hosts
        content {
          ip       = hosts.value.ip
          hostname = hosts.value.hostname
        }
      }

      # Add forwarders
      dynamic "forwarders" {
        for_each = var.network_dns_forwarders
        content {
          domain  = try(forwarders.value.domain, null)
          address = forwarders.value.addr
        }
      }
    }
  }

  # Add dnsmasq_options (only for NAT mode)
  dynamic "dnsmasq_options" {
    for_each = var.network_mode == "bridge" ? [] : [1]
    content {
      dynamic "options" {
        for_each = var.network_dnsmasq_options
        content {
          option_name  = options.value.option_name
          option_value = options.value.option_value
        }
      }
    }
  }
}
