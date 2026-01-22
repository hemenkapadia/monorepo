# Cluster represents logically related kvm domains/VMs also called cluster nodes

# Create Root OS Disk base image to be used for all nodes in the cluster in the Org Storage Pool 
resource "libvirt_volume" "cluster_os_disk_base_image" {
  name   = "${var.cluster_node_name_prefix}-os-disk-base-image"
  pool   = var.cluster_node_org_storage_pool_name
  source = var.cluster_node_os_disk_image_source
}

module "cluster_node_os_volumes" {
  source = "../volume"
  count  = var.cluster_node_count

  volume_name             = "${var.cluster_node_name_prefix}-node-${count.index + 1}-os-disk.qcow2"
  volume_pool             = var.cluster_node_org_storage_pool_name
  volume_base_volume_name = libvirt_volume.cluster_os_disk_base_image.name
  volume_size_gb          = var.cluster_node_os_disk_size_gb

  depends_on = [libvirt_volume.cluster_os_disk_base_image]
}

module "cluster_node_second_raw_block_device_volumes" {
  source = "../volume"
  count  = var.cluster_node_add_second_raw_block_device ? var.cluster_node_count : 0

  volume_name    = "${var.cluster_node_name_prefix}-node-${count.index + 1}-second-raw-block-device.qcow2"
  volume_pool    = var.cluster_node_org_storage_pool_name
  volume_size_gb = var.cluster_node_second_raw_block_device_size_gb
}


resource "libvirt_cloudinit_disk" "cluster_node_cloudinit" {
  count = var.cluster_node_count

  name = "${var.cluster_node_name_prefix}-node-${count.index + 1}-cloudinit-disk.iso"
  pool = var.cluster_node_org_storage_pool_name

  user_data = templatefile(var.cluster_node_cloudinit_userdata_file, {
    hostname           = "${var.cluster_node_name_prefix}-node-${count.index + 1}"
    username           = var.cluster_node_ssh_user
    ssh_authorized_key = file(var.cluster_node_ssh_user_public_key_file)
  })

  network_config = templatefile(var.cluster_node_cloudinit_network_config_file, {})

  meta_data = templatefile(var.cluster_node_cloudinit_metadata_file, {
    instance_id = "${var.cluster_node_name_prefix}-node-${count.index + 1}"
    hostname    = "${var.cluster_node_name_prefix}-node-${count.index + 1}"
  })
}


module "cluster_nodes" {
  source = "../domain"
  count  = var.cluster_node_count

  name = "${var.cluster_node_name_prefix}-node-${count.index + 1}"

  # Domain resources
  vCPU      = var.cluster_node_vCPU
  memory_gb = var.cluster_node_memory_gb
  disks = concat(
    [
      {
        volume_id = module.cluster_node_os_volumes[count.index].volume_id
        bus       = "virtio"
      }
    ],
    var.cluster_node_add_second_raw_block_device ? [
      {
        volume_id = module.cluster_node_second_raw_block_device_volumes[count.index].volume_id
        bus       = "virtio"
      }
    ] : []
  )
  network_interfaces = [
    {
      network_id     = var.cluster_node_org_network_id
      hostname       = "${var.cluster_node_name_prefix}-node-${count.index + 1}"
      wait_for_lease = true
    }
  ]

  enable_console = true

  cloudinit = {
    create    = false
    disk_id   = libvirt_cloudinit_disk.cluster_node_cloudinit[count.index].id
    pool_name = var.cluster_node_org_storage_pool_name
  }

  depends_on = [
    libvirt_cloudinit_disk.cluster_node_cloudinit,
    module.cluster_node_os_volumes,
    module.cluster_node_second_raw_block_device_volumes
  ]

}

