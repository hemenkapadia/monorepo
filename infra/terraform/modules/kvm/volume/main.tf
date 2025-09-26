# Storage Volume (disk image)

# Invalid configuration if:
#   size and source, both are not provided
#   size and source, both are provided
#   base volume and source, both are provided 
#   base volume is provided but size is not provided
locals {
  invalid_config = (
    (var.volume_size_gb == null && var.volume_source == null) ||
    (var.volume_size_gb != null && var.volume_source != null) ||
    (var.volume_base_volume_name != null && var.volume_source != null) ||
    (var.volume_base_volume_name != null && var.volume_size_gb == null)
  )
}

# Hard fail if both or neither are provided
resource "null_resource" "validate" {
  count = local.invalid_config ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Error: You must set either size or source (but not both) for libvirt_volume.' && exit 1"
  }
}

# Create volume from source image
resource "libvirt_volume" "from_source" {
  count  = var.volume_source != null ? 1 : 0
  name   = var.volume_name
  pool   = var.volume_pool
  source = var.volume_source
}

# Create empty volume of given size
resource "libvirt_volume" "from_size" {
  count            = var.volume_size_gb != null ? 1 : 0
  name             = var.volume_name
  pool             = var.volume_pool
  size             = abs(var.volume_size_gb * 1024 * 1024 * 1024)
  base_volume_name = var.volume_base_volume_name != null ? var.volume_base_volume_name : null
}

