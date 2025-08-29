# Validations & locals

## Ensure at least one disk
locals {
  # a boolean, set to true if var.disks is empty
  disk_count_invalid = length(var.disks) == 0

  # Validate each NIC has at least one of network_id or network_name
  invalid_nics = [
    for i, nic in var.network_interfaces : i
    if(
      (try(nic.network_id, null) == null) &&
      (try(nic.network_name, null) == null)
    )
  ]

  # Decide cloudinit id (if created or provided)
  # Cloudinit disk is created below if create is set to true
  cloudinit_id = (
    (try(var.cloudinit.create, false) ? try(libvirt_cloudinit_disk.cloudinit_disk[0].id, null) : null)
    != null
    ? libvirt_cloudinit_disk.cloudinit_disk[0].id
    : try(var.cloudinit.disk_id, null)
  )
}

# Hard fail (friendly messages) if invalid inputs
resource "null_resource" "validate" {
  count = (local.disk_count_invalid || length(local.invalid_nics) > 0) ? 1 : 0

  provisioner "local-exec" {
    command = join(" && ", compact([
      local.disk_count_invalid ? "echo 'ERROR: var.disks must include at least one disk (volume_id).'" : "",
      length(local.invalid_nics) > 0 ? "echo 'ERROR: Each network interface must set network_id or network_name. Offenders: ${join(", ", [for idx in local.invalid_nics : tostring(idx)])}.'" : "",
      "exit 1"
    ]))
  }
}

# Create Cloud Init Disk if cloudinit.create = true
resource "libvirt_cloudinit_disk" "cloudinit_disk" {
  count = try(var.cloudinit.create, false) ? 1 : 0

  name      = try(var.cloudinit.iso_name, "cloudinit.iso")
  pool      = var.cloudinit.pool_name
  user_data = try(var.cloudinit.user_data, null)
  # These two are optional; libvirt provider ignores empty fields
  meta_data      = try(var.cloudinit.meta_data, null)
  network_config = try(var.cloudinit.network_config, null)
}

# Create the domain
resource "libvirt_domain" "domain" {
  name = var.name

  # Core Properties
  vcpu   = var.vcpu
  memory = var.memory

  dynamic "disk" {
    for_each = { for i, d in var.disks : i => d }
    content {
      volume_id = disk.value.volume_id
      scsi      = (try(disk.value.bus, "virtio") == "scsi") ? true : false
      # For other buses, provider typically takes 'scsi=false' and infers bus from config.
      # The libvirt provider doesn't expose an explicit 'bus' attribute except via 'scsi' boolean.
    }
  }

  dynamic "network_interface" {
    for_each = { for i, nic in var.network_interfaces : i => nic }
    content {
      network_id     = try(network_interface.value.network_id, null)
      network_name   = try(network_interface.value.network_name, null)
      mac            = try(network_interface.value.mac, null)
      hostname       = try(network_interface.value.hostname, null)
      wait_for_lease = try(network_interface.value.wait_for_lease, true)
    }
  }

  # Additional Properties
  dynamic "console" {
    for_each = var.enable_console ? [1] : []
    content {
      type        = "pty"
      target_port = "0"
      target_type = "serial"
    }
  }

  dynamic "graphics" {
    for_each = var.graphics.enabled ? [1] : []
    content {
      type        = var.graphics.type
      listen_type = var.graphics.listen_type
      autoport    = var.graphics.autoport
    }
  }

  # Bootstrapping, setup cloudinit_id, either passed or created
  cloudinit = local.cloudinit_id

  # Startup options
  autostart = var.autostart
  running   = var.running
}
