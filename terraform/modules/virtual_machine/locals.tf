locals {
  guest_destination = "${var.guest_username}@${var.guest_ip}"
  guest_ssh_cmd     = "${var.ssh_cmd} ${local.guest_destination}"
}
