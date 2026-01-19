terraform {
  required_version = ">= 1.12.0"

  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "~> 0.9.0"
    }
    null = {
      source  = "null"
      version = "~> 3.2.0"
    }
  }
}
