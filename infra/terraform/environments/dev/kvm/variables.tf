# Global variables

## Common variables
variable "org_name" {
  type        = string
  description = "Organization Name. Used in name of all resources like Storage Pool, Volume, Domains etc."
}

## Storage Pool variables
variable "storage_pool_base_path" {
  type        = string
  description = "Base directory for the Storage Pool directories"
}

## Network variables
variable "domain" {
  type        = string
  description = "Domain of the libvirt network"
  default     = null
}

variable "address_cidr" {
  type        = list(string)
  description = "CIDR block for the libvirt NAT network"
}

variable "mode" {
  type        = string
  description = "Mode of the libvirt network"
  default     = "nat"
}

variable "autostart" {
  type        = bool
  description = "Autostart the libvirt network"
  default     = true
}

variable "dns_enabled" {
  type        = bool
  description = "Enable DNS for the libvirt network"
  default     = true
}

variable "dns_local_only" {
  type        = bool
  description = "Enable DNS for local only mode"
  default     = false
}

variable "dns_forwarders" {
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

variable "dns_hosts" {
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

## Volume variables
variable "os_images_base_path" {
  type        = string
  description = "Base directory for the Cloud OS images"
}


# Domain variables
