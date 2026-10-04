terraform {
  required_version = "~> 1.16.4"
  required_providers {
    libvirt = {
      source  = "dmacvicar/libvirt"
      version = "0.8.3"
    }
  }
}
