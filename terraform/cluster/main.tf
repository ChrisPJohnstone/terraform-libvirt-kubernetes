resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

resource "helm_release" "envoy_gateway_release" {
  depends_on = [kubernetes_namespace_v1.namespace]
  name = "envoy-gateway"
  chart = "oci://docker.io/envoyproxy/gateway-helm"
  version = var.envoy_gateway_version
  namespace = local.namespace
  create_namespace = false
}

module "prometheus" {
  source     = "./modules/prometheus/"
  namespace  = local.namespace
  config_path = "${var.config_dir}prometheus.yml"
}
