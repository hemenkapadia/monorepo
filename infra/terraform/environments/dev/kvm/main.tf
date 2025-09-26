locals {
  # Storage Pool variables
  org_storage_pool_name = "${var.org_name}-storage-pool"
  org_storage_pool_path = "${var.org_storage_pool_base_path}/${local.org_storage_pool_name}"
  # Network variables
  org_network_name   = "${var.org_name}-network"
  org_network_domain = (var.org_domain == null || var.org_domain == "") ? "${local.org_network_name}.home.arpa" : var.org_domain
}

module "org_storage_pool" {
  source    = "../../../modules/kvm/storage"
  pool_name = local.org_storage_pool_name
  pool_path = local.org_storage_pool_path
  pool_type = var.org_storage_pool_type
}

module "org_network" {
  source                 = "../../../modules/kvm/network"
  network_name           = local.org_network_name
  network_domain         = local.org_network_domain
  network_address_cidr   = var.org_network_address_cidr
  network_mode           = var.org_network_mode
  network_autostart      = var.org_network_autostart
  network_dns_enabled    = var.org_network_dns_enabled
  network_dns_local_only = var.org_network_dns_local_only
  network_dns_forwarders = var.org_network_dns_forwarders
  network_dns_hosts      = var.org_network_dns_hosts
}

module "kvm_cluster" {
  source = "../../../modules/kvm/cluster"

  cluster_node_name_prefix           = "${var.org_name}-${var.cluster_node_name_prefix}"
  cluster_node_count                 = var.cluster_node_count
  cluster_node_org_storage_pool_name = module.org_storage_pool.pool_name
  cluster_node_org_network_id        = module.org_network.network_id

  cluster_node_vCPU                            = var.cluster_node_vCPU
  cluster_node_memory_gb                       = var.cluster_node_memory_gb
  cluster_node_os_disk_image_source            = var.cluster_node_os_disk_image_source
  cluster_node_os_disk_size_gb                 = var.cluster_node_os_disk_size_gb
  cluster_node_add_second_raw_block_device     = var.cluster_node_add_second_raw_block_device
  cluster_node_second_raw_block_device_size_gb = var.cluster_node_second_raw_block_device_size_gb

  cluster_node_cloudinit_userdata_file       = "${path.module}/${var.cluster_node_cloudinit_userdata_file}"
  cluster_node_cloudinit_network_config_file = "${path.module}/${var.cluster_node_cloudinit_network_config_file}"
  cluster_node_cloudinit_metadata_file       = "${path.module}/${var.cluster_node_cloudinit_metadata_file}"

  cluster_node_ssh_user                 = var.cluster_node_ssh_user
  cluster_node_ssh_user_public_key_file = var.cluster_node_ssh_user_public_key_file

  depends_on = [
    module.org_storage_pool,
    module.org_network
  ]
}
