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

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [module.gaffer]
  triggers = {
    gaffer_ip = module.gaffer.guest_ip
  }
  provisioner "local-exec" {
    command = <<-EOF
      echo "Extraction kubeconfig"
      ssh ${var.guest_username}@${module.gaffer.guest_ip} 'sudo cat /etc/kubernetes/admin.conf' > ${var.kubeconfig_path}
    EOF
  }
}

module "workers" {
  for_each        = toset(["hoddit", "doddit"])
  source          = "./modules/virtual_machine"
  depends_on      = [null_resource.fetch_kubeconfig]
  guest_name      = each.key
  cloud_init_path = "./templates/cloudinit.yml"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
}
