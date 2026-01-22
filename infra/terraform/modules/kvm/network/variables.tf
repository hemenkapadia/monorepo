variable "network_name" {
  type        = string
  description = "Name of the libvirt network"
}

variable "network_domain" {
  type        = string
  description = "Domain of the libvirt network"
}

variable "network_address_cidr" {
  type        = list(string)
  description = "CIDR block(s) for the libvirt network (not used in bridge mode)"
  default     = []
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

variable "network_bridge" {
  type        = string
  description = "Bridge interface name (required when network_mode = 'bridge', e.g., 'br0')"
  default     = null
}

variable "network_autostart" {
  type        = bool
  description = "Autostart the libvirt network"
  default     = true
}

variable "network_dhcp_enabled" {
  type        = bool
  description = "Enable DHCP for the libvirt network (not used in bridge mode). Enabled by default for NAT mode"
  default     = true
}

variable "network_dns_enabled" {
  type        = bool
  description = "Enable DNS for the libvirt network (not used in bridge mode). Enabled by default for NAT mode"
  default     = true
}

variable "network_dns_local_only" {
  type        = bool
  description = "Enable DNS for local only mode"
  default     = false
}

variable "network_dns_forwarders" {
  type = list(object({
    domain  = string
    address = string
  }))
  default     = []
  description = <<EOT
List of DNS forwarders. 
Each object can have:
  - domain (optional string)
  - address   (string, e.g. 8.8.8.8)
EOT
}

variable "network_dns_hosts" {
  type = list(object({
    ip       = string
    hostname = string
  }))
  default     = []
  description = <<EOT
List of DNS host entries. 
Each object should have:
  - ip        (string)
  - hostname  (string)
EOT
}

variable "network_dnsmasq_options" {
  type = list(object({
    option_name  = string
    option_value = string
  }))
  default     = []
  description = <<EOT
List of dnsmasq options to be passed to the libvirt network.
Each object should have:
  - option_name  (string, e.g. "dhcp-option")
  - option_value (string, e.g. "6,8.8.8.8")
EOT
}