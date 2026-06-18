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
  default     = 2 * 1024
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

variable "network_interface" {
  description = "Network interface to connect to"
  type        = string
  nullable    = false
  default     = "default"
}

variable "console_type" {
  description = "Console type"
  type        = string
  nullable    = false
  default     = "pty"
}

variable "console_target_port" {
  description = "Console target port"
  type        = number
  nullable    = false
  default     = 0
}

variable "apt_key_dir" {
  description = "Directory for apt keys"
  type        = string
  nullable    = false
  default     = "/etc/apt/keyrings/"
}
