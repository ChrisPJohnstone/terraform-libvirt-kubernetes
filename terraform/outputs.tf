output "control_plane_ip" {
  value = module.control_plane.guest_ip
}

output "hoddit_ip" {
  value = module.hoddit.guest_ip
}

output "doddit_ip" {
  value = module.doddit.guest_ip
}
