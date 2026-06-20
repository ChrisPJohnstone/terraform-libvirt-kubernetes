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

module "hoddit" {
  source          = "./modules/virtual_machine"
  depends_on      = [module.gaffer]
  guest_name      = "hoddit"
  cloud_init_path = "./templates/cloudinit.yml"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
}

module "doddit" {
  source          = "./modules/virtual_machine"
  depends_on      = [module.gaffer]
  guest_name      = "doddit"
  cloud_init_path = "./templates/cloudinit.yml"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on      = [module.gaffer]
  triggers = {
    gaffer_ip = module.gaffer.guest_ip
  }
  provisioner "local-exec" {
    command = <<-EOF
      echo "Waiting on SSH connection"
      while ! ssh -o StrictHostKeyChecking=accept-new ${var.guest_username}@${module.gaffer.guest_ip} true; do sleep 5; done
      echo "Waiting on cloudinit"
      ssh ${var.guest_username}@${module.gaffer.guest_ip} 'cloud-init status --wait
      echo "Extraction kubeconfig"
      sudo cat /etc/kubernetes/admin.conf' > ${var.kubeconfig_path}
    EOF
  }
}

