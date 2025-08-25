variable "volume_name" {
  type        = string
  description = "Name of the volume"
}

variable "volume_pool" {
  type        = string
  description = "Name of the Storage Pool to use for this volume"
}

variable "volume_source" {
  type        = string
  default     = null
  description = "Source of image to be used for volume. Can be local or https remote url. Image will be uploaded to storage pool."
}

variable "volume_size_gb" {
  type        = number
  default     = null
  description = "Since of volume in bytes. Not needed when volume_source is specified."
}
