resource "libvirt_pool" "pool" {
  name = var.pool_name
  type = var.pool_type
  target {
    path = var.pool_target_path
  }
}
