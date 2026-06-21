resource "libvirt_volume" "guest_volume" {
  name   = "${var.guest_name}-volume.qcow2"
  pool   = var.pool_name
  source = var.volume_source
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "guest_seed" {
  name      = "${var.guest_name}-cloudinit.iso"
  pool      = var.pool_name
  meta_data = <<-EOF
    instance-id: ${var.guest_name}
    local-hostname: ${var.guest_name}
  EOF
  user_data = templatefile(var.cloud_init_path, {
    is_control_node = var.is_control_node
    guest_username  = var.guest_username
    ssh_public_key  = var.ssh_public_key
    apt_key_dir     = var.apt_key_dir
  })
}

resource "libvirt_domain" "guest" {
  depends_on = [
    libvirt_volume.guest_volume,
    libvirt_cloudinit_disk.guest_seed
  ]
  name      = var.guest_name
  type      = var.guest_type
  memory    = var.memory
  vcpu      = var.vcpu
  running   = true
  arch      = var.os_arch
  machine   = var.os_machine
  cloudinit = libvirt_cloudinit_disk.guest_seed.id

  boot_device {
    dev = ["hd"]
  }

  disk {
    volume_id = libvirt_volume.guest_volume.id
  }

  network_interface {
    network_name   = var.network_interface
    wait_for_lease = true
  }

  console {
    type        = var.console_type
    target_port = var.console_target_port
  }
}

resource "time_sleep" "wait_for_ip" {
  depends_on = [libvirt_domain.guest]
  triggers = {
    running  = libvirt_domain.guest.running
    guest_ip = local.guest_ip
  }
  create_duration = "10s"
}

resource "null_resource" "wait_for_cloudinit" {
  depends_on = [time_sleep.wait_for_ip]
  triggers = {
    running  = libvirt_domain.guest.running
    guest_ip = local.guest_ip
  }
  provisioner "local-exec" {
    command = <<-EOF
      [ "${local.guest_ip}" = "" ] && echo "Guest IP not provisioned in time, please retry deploy" && exit 1
      echo "Waiting on SSH connection"
      while ! ${local.guest_ssh_cmd} true; do sleep 10; done
      echo "Waiting on cloudinit"
      ${local.guest_ssh_cmd} 'cloud-init status --wait > /dev/null; rc=$?; [ $rc -eq 2 ] && rc=0; exit $rc'
    EOF
  }
}
