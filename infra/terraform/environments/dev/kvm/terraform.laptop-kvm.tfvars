# Global Organization level variables
# Only letters. Creates domain as org_name.libvirtdev.me
# org_name = "laptop-kvm"

# Storage Pool variables
org_storage_pool_base_path = "/var/lib/libvirt/images"

# Network variables
org_network_autostart            = true
org_network_mode                 = "nat"
org_network_nat_gateway_ip       = "192.168.75.1"
org_network_nat_netmask          = "255.255.255.0"
org_network_nat_dhcp_enabled     = true
org_network_nat_dhcp_range_start = "192.168.75.10"
org_network_nat_dhcp_range_end   = "192.168.75.20"
org_network_nat_dhcp_hosts = [
  {
    name = "test-host"
    ip   = "192.168.75.11"
    mac  = "52:54:00:12:34:56"
  },
  {
    name = "test-host-2"
    ip   = "192.168.75.12"
    mac  = "52:54:00:12:34:57"
  }
]
org_network_domain                  = "kvm.hemen.home.arpa"
org_network_dns_enabled             = true
org_network_dns_forward_plain_names = false
org_network_dns_host = [
  {
    ip = "192.168.75.11"
    hostnames = [{
      hostname = "test-host"
      }, {
      hostname = "test-host-alias"
    }]
  },
  {
    ip = "192.168.75.12"
    hostnames = [{
      hostname = "test-host-2"
      }, {
      hostname = "test-host-2-alias"
    }]
  }
]

# # Cluster variables
# cluster_node_name_prefix = "k8s-cluster"
# cluster_node_count       = 3
# ## Cluster Node Base OS disk and additional disk variables
# cluster_node_os_disk_image_source            = "/home/hemen/Downloads/CloudImages/CloudInit/noble-minimal-cloudimg-amd64.img"
# cluster_node_os_disk_size_gb                 = 20
# cluster_node_add_second_raw_block_device     = true
# cluster_node_second_raw_block_device_size_gb = 20
# ## Cluster Node CloudInit variables
# cluster_node_cloudinit_userdata_file       = "cloud_init/user-data.cfg"
# cluster_node_cloudinit_network_config_file = "cloud_init/network.cfg"
# cluster_node_cloudinit_metadata_file       = "cloud_init/meta-data.cfg"


# cluster_node_ssh_user                 = "libvirt"
# cluster_node_ssh_user_public_key_file = "cloud_init/id_ed25519_libvirt.pub"
