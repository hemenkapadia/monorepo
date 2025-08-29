# Domain Identifiers
variable "name" {
  description = "Domain (VM) name"
  type        = string
}

# Domain Core Properties (CPU, RAM, Disks, Network Interface)
variable "vcpu" {
  description = "Number of virtual CPUs"
  type        = number
  default     = 2
}

variable "memory" {
  description = "Memory in MB"
  type        = number
  default     = 2048
}

variable "disks" {
  description = <<EOT
List of disks to attach. Each disk requires a 'volume_id'.
Optional 'bus' (virtio, scsi, sata, ide). Default 'virtio'.

Example:
disks = [
  { volume_id = "vol-123", bus = "virtio" },
  { volume_id = "vol-456" } # defaults to virtio
]
EOT
  type = list(object({
    volume_id = string
    bus       = optional(string, "virtio")
  }))
}

variable "network_interfaces" {
  description = <<EOT
List of NICs to attach. Specify one of network_id OR network_name.
Optional 'hostname', 'mac', 'wait_for_lease' (default true).

Example:
network_interfaces = [
  { network_id = module.net.network_id, hostname = "app" },
  { network_name = "devnet", mac = "52:54:00:12:34:56" }
]
EOT
  type = list(object({
    network_id     = optional(string)
    network_name   = optional(string)
    hostname       = optional(string)
    mac            = optional(string)
    wait_for_lease = optional(bool, true)
  }))
  default = []
}

# Domain Additional Properties (Console & Graphics)
variable "enable_console" {
  description = "Attach a serial console (pty)"
  type        = bool
  default     = true
}

variable "graphics" {
  description = <<EOT
Graphics configuration. If 'enabled' is true, a graphics device is added.
Fields:
- type: spice|vnc (default: spice)
- listen_type: address|none (default: address)
- autoport: true|false (default: true)

Example:
graphics = {
  enabled     = true
  type        = "spice"
  listen_type = "address"
  autoport    = true
}
EOT
  type = object({
    enabled     = bool
    type        = optional(string, "spice")
    listen_type = optional(string, "address")
    autoport    = optional(bool, true)
  })
  default = {
    enabled = false
  }
}

# Domain Bootstrapping Cloud-init (optional)
variable "cloudinit" {
  description = <<EOT
Cloud-init configuration. Either supply an existing 'disk_id' OR
set 'create = true' and provide 'user_data' (and optionally meta/network data).
If creating, also provide a pool name and iso name.

Examples:
# Use an existing cloudinit disk
cloudinit = {
  disk_id = "some-cloudinit-disk-id"
}

# Create a new cloudinit disk
cloudinit = {
  create          = true
  pool_name       = "default"
  iso_name        = "app-ci.iso"
  user_data       = file("user-data.yaml")
  meta_data       = null
  network_config  = null
}

Notes:
- user_data/meta_data/network_config should be raw cloud-init YAML strings.
- If create=false and disk_id=null, no cloudinit is attached.
EOT
  type = object({
    # Option A: use existing disk
    disk_id = optional(string)

    # Option B: create disk
    create         = optional(bool, false)
    pool_name      = optional(string)
    iso_name       = optional(string, "cloudinit.iso")
    user_data      = optional(string)
    meta_data      = optional(string)
    network_config = optional(string)
  })
  default = {
    create = false
  }
}

# Domain Startup Options 
variable "autostart" {
  description = "Whether to autostart the domain with the host"
  type        = bool
  default     = false
}

variable "running" {
  description = "Set to false to stop instance. By default is true to start the instnace"
  type        = bool
  default     = true
}
