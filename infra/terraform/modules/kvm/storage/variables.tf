variable "pool_name" {
  type        = string
  description = "Name of the storage pool"
}

variable "pool_type" {
  type        = string
  description = "Type of the storage pool"
  default     = "dir"
}

variable "pool_path" {
  type        = string
  description = "Filesystem path for the storage pool"
}
