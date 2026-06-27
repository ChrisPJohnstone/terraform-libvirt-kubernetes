resource "kubernetes_config_map_v1" "prometheus_config" {
  metadata {
    name      = "prometheus-config"
    namespace = var.namespace
  }
  data = { "prometheus.yml" = file(var.config_path) }
}

resource "kubernetes_deployment_v1" "prometheus_deploy" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
  }
  spec {
    selector {
      match_labels = { app = "prometheus" }
    }
    template {
      metadata {
        labels = { app = "prometheus" }
      }
      spec {
        container {
          image = "prom/prometheus"
          name  = "prometheus"
          port { container_port = 9090 }
          volume_mount {
            name       = "config"
            mount_path = "/etc/prometheus"
          }
        }
        volume {
          name = "config"
          config_map { name = local.prometheus_config_map }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "prometheus_service" {
  metadata {
    name      = "prometheus"
    namespace = var.namespace
  }
  spec {
    type = "NodePort"
    selector = {
      app = "prometheus"
    }
    port {
      port        = 9090
      target_port = 9090
    }
  }
}

resource "kubernetes_manifest" "prometheus_http_route" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = "prometheus-route"
      namespace = var.namespace
    }
    spec = {
      parentRefs = [{ name = var.gateway_name }]
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
