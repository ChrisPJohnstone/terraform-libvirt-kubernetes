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
  depends_on = [module.metallb, module.envoy]
  source      = "./modules/prometheus/"
  namespace   = local.namespace
  config_path = "${var.config_dir}prometheus.yml"
  gateway_name = module.envoy.gateway_name
  domain      = var.domain
}
