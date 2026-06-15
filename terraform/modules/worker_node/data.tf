data "libvirt_domain_interface_addresses" "guest" {
  domain = libvirt_domain.guest.uuid
  source = "lease"
}
