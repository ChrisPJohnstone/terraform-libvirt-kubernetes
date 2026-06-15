variable "guest_name" {
  description = "Name of the guest"
  type        = string
  nullable    = false
}

variable "guest_username" {
  description = "Username to create on guest"
  type        = string
  nullable    = false
}

variable "ssh_public_key" {
  description = "SSH public key to inject for root key-based auth"
  type        = string
  nullable    = false
}

variable "pool_name" {
  description = "Pool for the guest"
  type        = string
  nullable    = true
}

variable "volume_source" {
  description = "Source for the volume"
  type        = string
  nullable    = false
  default     = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-genericcloud-amd64.qcow2"
}

variable "guest_type" {
  description = "Type of the guest"
  type        = string
  nullable    = false
  default     = "kvm"
}

variable "memory" {
  description = "Maximum memory allocation for the vm at boot time"
  type        = number
  nullable    = false
  default     = 2
}

variable "memory_unit" {
  description = "Unit for memory allocation"
  type        = string
  nullable    = false
  default     = "Gb"
}

variable "vcpu" {
  description = "Number of Virtual CPU's allocated"
  type        = number
  nullable    = false
  default     = 2
}

variable "running" {
  description = "Wether guest should be started after creation"
  type        = bool
  nullable    = false
  default     = false
}

variable "os_type" {
  description = "OS Type"
  type        = string
  nullable    = false
  default     = "hvm"
}

variable "os_arch" {
  description = "OS Architecture"
  type        = string
  nullable    = false
  default     = "x86_64"
}

variable "os_machine" {
  description = "OS Machine Type"
  type        = string
  nullable    = false
  default     = "pc"
}

variable "target_device" {
  description = "Target device"
  type        = string
  nullable    = false
  default     = "vda"
}

variable "target_bus" {
  description = "Target bus"
  type        = string
  nullable    = false
  default     = "virtio"
}

variable "disk_driver_type" {
  description = "Driver Type"
  type        = string
  nullable    = false
  default     = "qcow2"
}

variable "network_bridge" {
  description = "Network bridge to connect to"
  type        = string
  nullable    = false
  default     = "virbr0"
}

variable "network_interface" {
  description = "Network interface to connect to"
  type        = string
  nullable    = false
  default     = "default"
}

variable "network_interface_model" {
  description = "Network interface model type"
  type        = string
  nullable    = false
  default     = "virtio"
}

variable "serial_type" {
  description = "Serial type"
  type        = string
  nullable    = false
  default     = "pty"
}

variable "serial_target_port" {
  description = "Serial target port"
  type        = number
  nullable    = false
  default     = 0
}

variable "console_type" {
  description = "Console type"
  type        = string
  nullable    = false
  default     = "pty"
}

variable "console_target_type" {
  description = "Console target type"
  type        = string
  nullable    = false
  default     = "serial"
}

variable "console_target_port" {
  description = "Console target port"
  type        = number
  nullable    = false
  default     = 0
}
