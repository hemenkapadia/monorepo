## Cluster variables
variable "cluster_node_name_prefix" {
  type        = string
  description = "Prefix for the cluster nodes"
}

variable "cluster_node_count" {
  type        = number
  description = "Number of nodes in the cluster"
  default     = 1
}

variable "cluster_node_org_storage_pool_name" {
  type        = string
  description = "Name of the org storage pool to use for cluster node disks"
}

variable "cluster_node_org_network_id" {
  type        = string
  description = "The ID of the org network the cluster nodes connect to"
}

## Cluster Nodes cloud-init variables
variable "cluster_node_cloudinit_userdata_file" {
  type        = string
  description = "Full path to CloudInit user-data configuration file"
}

variable "cluster_node_cloudinit_network_config_file" {
  type        = string
  description = "Full path to CloudInit network configuration file"
}

variable "cluster_node_cloudinit_metadata_file" {
  type        = string
  description = "Full path to CloudInit meta-data configuration file"
}

## Cluster Nodes Resource variables
variable "cluster_node_vCPU" {
  type        = number
  description = "Number of vCPUs for each cluster node"
  default     = 2
}

variable "cluster_node_memory_gb" {
  type        = number
  description = "Amount of memory (in MB) for each cluster node"
  default     = 4
}

## Cluster Node Disk variables
variable "cluster_node_os_disk_image_source" {
  type        = string
  description = "OS image file (qcow2) source for the root disk of each cluster node. Local and Remote location (https only) supported."
}

variable "cluster_node_os_disk_size_gb" {
  type        = number
  description = "Size of the OS disk for each cluster node in GB"
  default     = 20
}

variable "cluster_node_add_second_raw_block_device" {
  type        = bool
  description = "Whether to add a second raw block device to each cluster node"
  default     = false
}

variable "cluster_node_second_raw_block_device_size_gb" {
  type        = number
  description = "Size of the second raw block device for each cluster node in GB"
  default     = 10
}

## Cluster Nodes ssh variables
variable "cluster_node_ssh_user" {
  type        = string
  description = "Username for the ssh user. This user has password-less sudo capability"
  default     = "libvirt"
}

variable "cluster_node_ssh_user_public_key_file" {
  type        = string
  description = "Full path to Public SSH key for domain_user. The corresponding private key is used to ssh to the domain"
}
