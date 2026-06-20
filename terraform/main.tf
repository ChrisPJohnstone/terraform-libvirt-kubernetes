module "resource_pool" {
  source    = "./modules/libvirt_pool"
  pool_name = "kubernetes"
}

module "gaffer" {
  source          = "./modules/virtual_machine"
  depends_on      = [module.resource_pool]
  is_control_node = true
  guest_name      = "gaffer"
  cloud_init_path = "./templates/cloudinit.yml"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
}

# module "hoddit" {
#   source          = "./modules/virtual_machine"
#   depends_on      = [module.gaffer]
#   guest_name      = "hoddit"
#   cloud_init_path = "./templates/cloudinit.yml"
#   guest_username  = var.guest_username
#   ssh_public_key  = file(pathexpand(var.ssh_key_path))
#   pool_name       = module.resource_pool.pool.name
# }
#
# module "doddit" {
#   source          = "./modules/virtual_machine"
#   depends_on      = [module.gaffer]
#   guest_name      = "doddit"
#   cloud_init_path = "./templates/cloudinit.yml"
#   guest_username  = var.guest_username
#   ssh_public_key  = file(pathexpand(var.ssh_key_path))
#   pool_name       = module.resource_pool.pool.name
# }
