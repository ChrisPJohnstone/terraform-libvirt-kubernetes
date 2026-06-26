module "resource_pool" {
  source    = "./modules/libvirt_pool"
  pool_name = "kubernetes"
}

module "gaffer" {
  source          = "./modules/virtual_machine"
  depends_on      = [module.resource_pool]
  is_control_node = true
  guest_name      = "gaffer"
  template_dir    = "./templates/"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
  ssh_cmd         = var.ssh_cmd
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [module.gaffer]
  triggers = {
    gaffer_ip = module.gaffer.guest_ip
  }
  provisioner "local-exec" {
    command = <<-EOF
      echo "Extraction kubeconfig"
      ${var.ssh_cmd} ${local.gaffer_destination} 'sudo cat /etc/kubernetes/admin.conf' > ${var.kubeconfig_path}
    EOF
  }
}

module "workers" {
  for_each        = toset(["hoddit", "doddit"])
  source          = "./modules/virtual_machine"
  depends_on      = [null_resource.fetch_kubeconfig]
  guest_name      = each.key
  template_dir    = "./templates/"
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
  ssh_cmd         = var.ssh_cmd
}

resource "null_resource" "connect_workers" {
  depends_on = [module.workers]
  for_each   = toset(["hoddit", "doddit"])
  triggers = {
    worker_ips = module.workers[each.key].guest_ip
  }
  provisioner "local-exec" {
    command = <<-EOF
      echo "Connecting ${each.key} to cluster"
      JOIN_CMD=$(${var.ssh_cmd} ${local.gaffer_destination} "sudo kubeadm token create --print-join-command 2>/dev/null")
      ${var.ssh_cmd} ${var.guest_username}@${module.workers[each.key].guest_ip} "sudo $JOIN_CMD"
    EOF
  }
}
