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
  description = "CIDR block for the libvirt NAT network"
}

variable "network_mode" {
  type        = string
  description = "Mode of the libvirt network"
  default     = "nat"
}

variable "network_autostart" {
  type        = bool
  description = "Autostart the libvirt network"
  default     = true
}

variable "network_dns_enabled" {
  type        = bool
  description = "Enable DNS for the libvirt network"
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
