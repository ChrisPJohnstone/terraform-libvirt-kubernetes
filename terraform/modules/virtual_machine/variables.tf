variable "is_control_node" {
  description = "Wether this is the control node"
  type        = bool
  nullable    = false
  default     = false
}

variable "guest_name" {
  description = "Name of the guest"
  type        = string
  nullable    = false
}

variable "template_dir" {
  description = "Directory with cloudinit templates"
  type        = string
  nullable    = false
}

variable "guest_network_interface" {
  description = "Network interface name inside the guest"
  type        = string
  nullable    = false
  default     = "ens3"
}

variable "guest_ip" {
  description = "Static IP address for the guest (e.g. 192.168.122.10/24)"
  type        = string
  nullable    = false
}

variable "guest_gateway" {
  description = "Default gateway for the guest"
  type        = string
  nullable    = false
  default     = "192.168.122.1"
}

variable "guest_dns_servers" {
  description = "DNS servers for the guest"
  type        = list(string)
  nullable    = false
  default     = ["8.8.8.8", "1.1.1.1"]
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

variable "apt_key_dir" {
  description = "Directory for apt keys"
  type        = string
  nullable    = false
  default     = "/etc/apt/keyrings/"
}

variable "pool_name" {
  description = "Pool for the guest"
  type        = string
  nullable    = true
}

variable "base_volume_id" {
  description = "ID of base volume"
  type        = string
  nullable    = false
}

variable "volume_size" {
  description = "Size of the volume"
  type        = number
  nullable    = false
  default     = 16 * 1024 * 1024 * 1024 # 16 Gb
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

variable "ssh_cmd" {
  description = "Base SSH command to use"
  type        = string
  nullable    = false
  default     = "ssh"
}
