variable "network_name" {
  type        = string
  description = "Name of the libvirt network"
}

variable "network_autostart" {
  type        = bool
  description = "Autostart the libvirt network"
  default     = true
}

variable "network_mode" {
  type        = string
  description = "Mode of the libvirt network. Options: 'nat' (default) or 'bridge'"
  default     = "nat"
  validation {
    condition     = contains(["nat", "bridge"], var.network_mode)
    error_message = "network_mode must be either 'nat' or 'bridge'"
  }
}

variable "network_bridge_interface_name" {
  type        = string
  description = "Bridge interface name (required when network_mode = 'bridge', e.g., 'br0')"
  default     = null
  validation {
    condition     = var.network_mode == "bridge" ? var.network_bridge_interface_name != null : true
    error_message = "network_bridge_interface_name is required when network_mode is 'bridge'"
  }
}

variable "network_domain" {
  type        = string
  description = "Domain of the libvirt network. Used only in NAT mode"
}

variable "network_domain_local_only" {
  type        = bool
  description = "If enabled, DNS requests are not forwarded to the host's upstream DNS server. Used only in NAT mode"
  default     = false
}

variable "network_dns_enabled" {
  type        = bool
  description = "Enable DNS for the libvirt network (not used in bridge mode). Enabled by default for NAT mode"
  default     = true
}

variable "network_dns_forward_plain_names" {
  type        = bool
  description = "Forward plain names (e.g., 'machine1') to the host's upstream DNS server"
  default     = false
}

variable "network_dns_forwarders" {
  type = list(object({
    domain = string
    addr   = string
  }))
  default     = []
  description = <<EOT
List of DNS forwarders. 
Each object can have:
  - domain (optional string)
  - addr   (string, e.g. 8.8.8.8)
EOT
}

variable "network_dns_host" {
  type = list(object({
    ip = string
    hostnames = list(object({
      hostname = string
    }))
  }))
  default     = []
  description = <<EOT
List of DNS host entries. 
Each object should have:
  - ip        (string)
  - hostnames  (list of objects with hostname attribute)
EOT
}

variable "network_nat_gateway_ip" {
  type        = string
  description = "Gateway IP for the libvirt network (not used in bridge mode)"
}

variable "network_nat_netmask" {
  type        = string
  description = "Netmask for the libvirt network (not used in bridge mode)"
}

variable "network_nat_dhcp_range_start" {
  type        = string
  description = "Start address for the libvirt network (not used in bridge mode)"
}

variable "network_nat_dhcp_range_end" {
  type        = string
  description = "End address for the libvirt network (not used in bridge mode)"
}

variable "network_nat_dhcp_hosts" {
  type = list(object({
    ip   = string
    name = string
    mac  = string
  }))
  default     = []
  description = <<EOT
List of DHCP host entries. 
Each object should have:
  - ip        (string)
  - name      (string)
  - mac       (string)
EOT
}
