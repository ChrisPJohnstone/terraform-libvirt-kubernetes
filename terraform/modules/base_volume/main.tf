resource "libvirt_volume" "base_volume" {
  name   = "debian-13-base.qcow2"
  pool   = var.pool_name
  source = var.volume_source
  format = "qcow2"
}
