output "pool" {
  value = {
    name   = libvirt_pool.pool.name
    target = libvirt_pool.pool.target
  }
  description = "The libvirt pool"
}
