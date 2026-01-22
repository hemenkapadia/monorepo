# Global Organization level variables
# Only letters. Creates domain as org_name.libvirtdev.me
org_name = "laptop-kvm"

# Storage Pool variables
org_storage_pool_base_path = "/var/lib/libvirt/images"
org_storage_pool_type      = "dir"

# Network variables
org_network_domain       = "laptop-kvm.hemen.home.arpa"
org_network_address_cidr = ["192.168.75.0/24"]
org_network_mode         = "nat"
org_network_autostart    = true
org_network_dhcp_enabled = true
org_network_dns_enabled  = true
org_network_dns_local_only = false
org_network_dns_forwarders = [
  {
    domain  = "hemen.home.arpa"
    address = "192.168.114.31"
  }
]

# org_network_dns_hosts = [
#   {
#     hostname = "static_host_1"
#     ip       = "192.168.75.41"
#   },
#   {
#     hostname = "static_host_2"
#     ip       = "192.168.75.42"
#   }
# ]
# org_network_dnsmasq_options = [
#   {
#     option_name  = "address"
#     option_value = "/something.hklibvirt.home.arpa/192.168.75.55"
#   }
# ]

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
