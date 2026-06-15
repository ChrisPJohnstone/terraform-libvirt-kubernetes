resource "libvirt_pool" "pool" {
  name = var.pool_name
  type = var.pool_type
  create = {
    build     = true
    start     = true
    autostart = true
  }
  destroy = {
    delete = false
  }
  target = {
    path = var.pool_target_path
  }
}
