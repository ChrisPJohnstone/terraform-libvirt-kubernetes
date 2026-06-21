locals {
  guest_ip = try(libvirt_domain.guest.network_interface[0].addresses[0], "")
}
