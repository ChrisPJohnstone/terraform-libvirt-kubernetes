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

variable "envoy_gateway_version" {
  description = "Version of envoy gateway to install"
  type        = string
  nullable    = false
  default     = "1.8.1"
}
