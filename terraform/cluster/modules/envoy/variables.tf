variable "namespace" {
  description = "Namespace to create resources under"
  type        = string
  nullable    = false
}

variable "envoy_gateway_version" {
  description = "Version of envoy gateway to install"
  type        = string
  nullable    = false
  default     = "1.8.1"
}

variable "gatewayclass_name" {
  description = "Name to create GatewayClass under"
  type        = string
  nullable    = false
  default     = "envoy-gatewayclass"
}

variable "gatewayclass_api_version" {
  description = "API Version for GatewayClass"
  type        = string
  nullable    = false
  default     = "gateway.networking.k8s.io/v1"
}

variable "gateway_api_version" {
  description = "API Version for Gateway"
  type        = string
  nullable    = false
  default     = "gateway.networking.k8s.io/v1"
}
