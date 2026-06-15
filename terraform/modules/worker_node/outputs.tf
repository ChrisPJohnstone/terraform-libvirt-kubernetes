output "guest_name" {
  value = libvirt_domain.guest.name
}

output "guest_ip" {
  description = "IP address of the guest (from DHCP lease)"
  value       = try(data.libvirt_domain_interface_addresses.guest.interfaces[0].addrs[0].addr, null)
}
