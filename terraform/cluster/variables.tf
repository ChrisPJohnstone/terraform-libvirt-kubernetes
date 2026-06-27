variable "kubeconfig_path" {
  description = "Where to store kubeconfig"
  type        = string
  nullable    = false
  default     = "../kubeconfig"
}

variable "config_dir" {
  description = "Directory with configs"
  type        = string
  nullable    = false
  default     = "./configs/"
}

variable "namespace" {
  description = "Name to create namespace under"
  type        = string
  nullable    = false
  default     = "lab"
}
