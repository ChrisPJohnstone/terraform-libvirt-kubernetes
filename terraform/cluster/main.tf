resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "metallb" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/metallb/"
  namespace  = local.namespace
}

module "envoy" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/envoy/"
  namespace  = local.namespace
}

module "prometheus" {
  depends_on  = [kubernetes_namespace_v1.namespace]
  source      = "./modules/prometheus/"
  namespace   = local.namespace
  config_path = "${var.config_dir}prometheus.yml"
}

resource "kubernetes_manifest" "prometheus_http_route" {
  depends_on = [module.envoy, module.prometheus]
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "prometheus-route"
      namespace = local.namespace
    }
    spec = {
      parentRefs = [{ name = module.envoy.gateway_name }]
      hostnames = ["prometheus.${var.domain}"]
      rules = [{
        backendRefs = [{
          name = "prometheus"
          port = 9090
        }]
      }]
    }
  }
}
