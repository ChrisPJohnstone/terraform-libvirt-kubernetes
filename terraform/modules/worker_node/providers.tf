terraform {
  required_version = "~> 1.15.6"
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
      version = "0.8.3"
    }
    http = {
      source = "hashicorp/http"
      version = "3.6.0"
    }
  }
}
