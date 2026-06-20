variable "guest_username" {
  description = "Username to create on guest"
  type        = string
  nullable    = false
  default     = "chris"
}

variable "ssh_key_path" {
  description = "Path to SSH public key"
  type        = string
  nullable    = false
  default     = "~/.ssh/id_ed25519.pub"
}
