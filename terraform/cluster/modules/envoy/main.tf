resource "helm_release" "envoy_gateway_release" {
  name = "envoy-gateway"
  chart = "oci://docker.io/envoyproxy/gateway-helm"
  version = var.envoy_gateway_version
  namespace = var.namespace
  create_namespace = false
}

resource "kubernetes_manifest" "envoy_gatewayclass" {
  depends_on = [helm_release.envoy_gateway_release]
  manifest = {
    apiVersion = var.gatewayclass_api_version
    kind = "GatewayClass"
    metadata = {
      name = var.gatewayclass_name
    }
    spec = {
      controllerName = "gateway.envoyproxy.io/gatewayclass-controller"
    }
  }
}

resource "kubernetes_manifest" "envoy_gateway" {
  depends_on = [kubernetes_manifest.envoy_gatewayclass]
  manifest = {
    apiVersion = var.gateway_api_version
    kind = "Gateway"
    metadata = {
      name = "envoy-gateway"
      namespace = var.namespace
    }
    spec = {
      gatewayClassName = var.gatewayclass_name
      listeners = [{
        name = "http"
        protocol = "HTTP"
        port = 80
      }]
    }
  }
}

