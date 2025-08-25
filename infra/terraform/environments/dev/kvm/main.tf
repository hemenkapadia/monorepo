module "pool" {
  source    = "../../../modules/kvm/storage"
  pool_name = "${var.org_name}-pool"
  pool_type = "dir"
  pool_path = "${var.storage_pool_base_path}/${var.org_name}-pool"
}

module "network" {
  source                 = "../../../modules/kvm/network"
  network_name           = "${var.org_name}-net"
  network_domain         = (var.domain == null || var.domain == "") ? "${var.org_name}.dev" : var.domain
  network_address_cidr   = var.address_cidr
  network_mode           = var.mode
  network_autostart      = var.autostart
  network_dns_enabled    = var.dns_enabled
  network_dns_local_only = var.dns_local_only
  network_dns_forwarders = var.dns_forwarders
  network_dns_hosts      = var.dns_hosts
}

module "volume" {
  source        = "../../../modules/kvm/volume"
  volume_name   = "alpine"
  volume_pool   = module.pool.pool_name
  volume_source = "${var.os_images_base_path}/generic_alpine-3.21.4-x86_64-uefi-cloudinit-r0.qcow2"
}
