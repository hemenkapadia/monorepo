# Organization variables
variable "org_name" {
  type        = string
  description = "Organization Name. Used in name of all resources like Storage Pool, Volume, Domains etc."
}

## Storage Pool variables
variable "org_storage_pool_base_path" {
  type        = string
  description = "Base directory for the Organization's Storage Pool directories"
}
variable "org_storage_pool_type" {
  type        = string
  description = "Type of the Organization's Storage Pool"
  default     = "dir"
}

## Network variables
variable "org_network_autostart" {
  type        = bool
  description = "Autostart the Organization network"
  default     = true
}

variable "org_network_mode" {
  type        = string
  description = "Mode of the Organization's network"
  default     = "nat"
}

variable "org_network_bridge_interface_name" {
  type        = string
  description = "Bridge interface name (required when network_mode = 'bridge', e.g., 'br0')"
  default     = null
}

variable "org_network_domain" {
  type        = string
  description = "Network Domain for the Organization"
  default     = null
}

variable "org_network_domain_local_only" {
  type        = bool
  description = "Enable DNS for local only mode"
  default     = false
}

variable "org_network_nat_gateway_ip" {
  type        = string
  description = "Gateway IP for the libvirt network (not used in bridge mode)"
  default     = null
}

variable "org_network_nat_netmask" {
  type        = string
  description = "Netmask for the libvirt network (not used in bridge mode)"
  default     = null
}

variable "org_network_nat_dhcp_range_start" {
  type        = string
  description = "Start address for the libvirt network (not used in bridge mode)"
  default     = null
}

variable "org_network_nat_dhcp_range_end" {
  type        = string
  description = "End address for the libvirt network (not used in bridge mode)"
  default     = null
}

variable "org_network_nat_dhcp_hosts" {
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

variable "org_network_dns_enabled" {
  type        = bool
  description = "Enable DNS for the Organization network"
  default     = true
}

variable "org_network_dns_forward_plain_names" {
  type        = bool
  description = "Forward plain names (e.g., 'machine1') to the host's upstream DNS server"
  default     = false
}

variable "org_network_dns_forwarders" {
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

variable "org_network_dns_host" {
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

# # Cluster variables
# variable "cluster_node_name_prefix" {
#   type        = string
#   description = "Prefix for the cluster nodes"
# }

# variable "cluster_node_count" {
#   type        = number
#   description = "Number of nodes in the cluster"
#   default     = 1
# }

# variable "cluster_node_vCPU" {
#   type        = number
#   description = "Number of vCPUs for each cluster node"
#   default     = 2
# }

# variable "cluster_node_memory_gb" {
#   type        = number
#   description = "Amount of memory (in GB) for each cluster node"
#   default     = 4
# }

# ## Cluster Node Base OS Variables
# variable "cluster_node_os_disk_image_source" {
#   type        = string
#   description = "Absolute path to source OS image file (qcow2) for the root disk of each node. Local and Remote location (https only) supported"
# }

# variable "cluster_node_os_disk_size_gb" {
#   type        = number
#   description = "Size of the OS disk for each cluster node in GB"
# }

# ## Cluster Node second raw block device variables. Usually needed for K8S setup with Rook + Ceph
# variable "cluster_node_add_second_raw_block_device" {
#   type        = bool
#   description = "Whether to add a second raw block device to each cluster node, used usually for Rook+Ceph when setting up K8S cluster."
#   default     = false
# }

# variable "cluster_node_second_raw_block_device_size_gb" {
#   type        = number
#   description = "Size of the second raw block device for each cluster node in GB"
#   default     = 10
# }
# ## Cluster Node cloud-init variables
# variable "cluster_node_cloudinit_userdata_file" {
#   type        = string
#   description = "path.module relative path to CloudInit user-data configuration file"
# }

# variable "cluster_node_cloudinit_network_config_file" {
#   type        = string
#   description = "path.module relative path to CloudInit network configuration file"
# }

# variable "cluster_node_cloudinit_metadata_file" {
#   type        = string
#   description = "path.module relative path to CloudInit meta-data configuration file"
# }

# # Cluster Node ssh user configuration variables
# variable "cluster_node_ssh_user" {
#   type        = string
#   description = "Username for the ssh user. This user has password-less sudo capability"
#   default     = "libvirt"
# }

# variable "cluster_node_ssh_user_public_key_file" {
#   type        = string
#   description = "path.module relative path to Public SSH key for domain_user. The corresponding private key is used to ssh to the domain"
# }
