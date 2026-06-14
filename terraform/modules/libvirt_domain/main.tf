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
    disks = [{
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
    }]
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
