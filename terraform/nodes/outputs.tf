output "gaffer_ip" {
  value = module.gaffer.guest_ip
}

output "hoddit_ip" {
  value = module.workers["hoddit"].guest_ip
}

output "doddit_ip" {
  value = module.workers["doddit"].guest_ip
}
