variable "pool_name" {
  description = "Name for resource pool"
  type        = string
  nullable    = false
}

variable "pool_type" {
  description = "Type for resource pool"
  type        = string
  nullable    = false
  default     = "dir"
}

variable "pool_target_path" {
  description = "Path for pool target"
  type        = string
  nullable    = false
  default     = "/var/lib/libvirt/data"
}
