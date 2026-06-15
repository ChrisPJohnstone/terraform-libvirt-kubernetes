terraform {
  required_version = "~> 1.15.6"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      # TODO: Check if version constraint can be loosened
      version = "0.9.8"
    }
  }
}
