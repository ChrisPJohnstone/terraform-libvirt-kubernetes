resource "libvirt_cloudinit_disk" "guest_seed" {
  name = "${var.guest_name}-cloudinit"
  user_data = <<-EOF
    #cloud-config
    disable_root: true
    users:
      - name: ${var.guest_username}
        ssh_authorized_keys:
          - ${var.ssh_public_key}
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
  EOF
  meta_data = <<-EOF
    instance-id: ${var.guest_name}
    local-hostname: ${var.guest_name}
  EOF
  network_config = <<-EOF
    version: 2
    ethernets:
      enp0s3:
        dhcp4: true
  EOF
}

resource "libvirt_volume" "guest_seed_volume" {
  name = "${var.guest_name}-cloudinit.iso"
  pool = var.pool_name

  create = {
    content = {
      url = libvirt_cloudinit_disk.guest_seed.path
    }
  }
}

resource "libvirt_domain" "guest" {
  name        = var.guest_name
  type        = var.guest_type
  memory      = var.memory
  memory_unit = var.memory_unit
  vcpu        = var.vcpu
  running     = var.running
  os = {
    type         = var.os_type
    type_arch    = var.os_arch
    type_machine = var.os_machine
    boot_devices = [{ dev = "hd" }]
  }
  devices = {
    disks = [
      {
        source = {
          volume = {
            pool   = var.pool_name
            volume = var.volume_name
          }
        }
        target = {
          dev = var.target_device
          bus = var.target_bus
        }
        driver = {
          type = var.disk_driver_type
        }
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_volume.guest_seed_volume.pool
            volume = libvirt_volume.guest_seed_volume.name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
      }
    ]
    interfaces = [
      {
        source = {
          bridge = {
            bridge = var.network_bridge
          }
        }
      },
      {
        source = {
          network = {
            network = var.network_interface
          }
        }
        model = {
          type = var.network_interface_model
        }
        wait_for_ip = {
          timeout = 300
          source  = "lease"
        }
      }
    ]
    serials = [{
      type        = var.serial_type
      target_port = var.serial_target_port
    }]
    consoles = [{
      type        = var.console_type
      target_type = var.console_target_type
      target_port = var.console_target_port
    }]
  }
}
