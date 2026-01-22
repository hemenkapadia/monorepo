# Storage Pool
resource "libvirt_pool" "storage_pool" {
  name = var.pool_name
  type = var.pool_type
  target {
    path = var.pool_path
  }
}
