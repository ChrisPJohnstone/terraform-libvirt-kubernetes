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
