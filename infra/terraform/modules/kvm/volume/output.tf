output "volume_id" {
  value = (
    length(libvirt_volume.from_source) > 0 ?
    libvirt_volume.from_source[0].id :
    libvirt_volume.from_size[0].id
  )
}

output "volume_name" {
  value = (
    length(libvirt_volume.from_source) > 0 ?
    libvirt_volume.from_source[0].name :
    libvirt_volume.from_size[0].name
  )
}
