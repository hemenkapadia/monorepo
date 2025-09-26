# Global Organization level variables
# Only letters. Creates domain as org_name.libvirtdev.me
org_name = "hklibvirt"

# Storage Pool variables
org_storage_pool_base_path = "/var/lib/libvirt/images"

# Network variables
org_network_address_cidr = ["192.168.75.0/24"]


# Cluster variables
cluster_node_name_prefix = "k8s-cluster"
cluster_node_count       = 3
## Cluster Node Base OS disk and additional disk variables
cluster_node_os_disk_image_source            = "/home/hemen/Downloads/CloudImages/CloudInit/noble-minimal-cloudimg-amd64.img"
cluster_node_os_disk_size_gb                 = 20
cluster_node_add_second_raw_block_device     = true
cluster_node_second_raw_block_device_size_gb = 20
## Cluster Node CloudInit variables
cluster_node_cloudinit_userdata_file       = "cloud_init/user-data.cfg"
cluster_node_cloudinit_network_config_file = "cloud_init/network.cfg"
cluster_node_cloudinit_metadata_file       = "cloud_init/meta-data.cfg"


cluster_node_ssh_user                 = "libvirt"
cluster_node_ssh_user_public_key_file = "cloud_init/id_ed25519_libvirt.pub"
