resource "kubernetes_namespace_v1" "namespace" {
  metadata { name = var.namespace }
}

module "envoy" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source = "./modules/envoy/"
  namespace  = local.namespace
}

module "prometheus" {
  depends_on = [kubernetes_namespace_v1.namespace]
  source     = "./modules/prometheus/"
  namespace  = local.namespace
  config_path = "${var.config_dir}prometheus.yml"
}
