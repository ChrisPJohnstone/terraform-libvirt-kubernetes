module "resource_pool" {
  source    = "./modules/libvirt_pool"
  pool_name = "kubernetes"
}

module "base_volume" {
  source     = "./modules/base_volume/"
  depends_on = [module.resource_pool]
  pool_name  = module.resource_pool.pool.name
}

module "gaffer" {
  source          = "./modules/virtual_machine"
  depends_on      = [module.base_volume]
  is_control_node = true
  guest_name      = "gaffer"
  template_dir    = "./templates/"
  base_volume_id  = module.base_volume.volume_id
  guest_username  = var.guest_username
  ssh_public_key  = file(pathexpand(var.ssh_key_path))
  pool_name       = module.resource_pool.pool.name
  ssh_cmd         = var.ssh_cmd
  guest_ip        = var.node_ips["gaffer"]
}

resource "null_resource" "fetch_kubeconfig" {
  depends_on = [module.gaffer]
  provisioner "local-exec" {
    command = <<-EOF
      echo "Extraction kubeconfig"
      ${var.ssh_cmd} ${local.gaffer_destination} 'sudo cat /etc/kubernetes/admin.conf' > ${var.kubeconfig_path}
    EOF
  }
}

module "workers" {
  for_each       = var.workers
  source         = "./modules/virtual_machine"
  depends_on     = [null_resource.fetch_kubeconfig]
  guest_name     = each.key
  template_dir   = "./templates/"
  base_volume_id = module.base_volume.volume_id
  guest_username = var.guest_username
  ssh_public_key = file(pathexpand(var.ssh_key_path))
  pool_name      = module.resource_pool.pool.name
  ssh_cmd        = var.ssh_cmd
  guest_ip       = var.node_ips[each.key]
}

resource "null_resource" "connect_workers" {
  depends_on = [module.workers]
  for_each   = var.workers
  provisioner "local-exec" {
    command = <<-EOF
      echo "Connecting ${each.key} to cluster"
      JOIN_CMD=$(${var.ssh_cmd} ${local.gaffer_destination} "sudo kubeadm token create --print-join-command 2>/dev/null")
      ${var.ssh_cmd} ${var.guest_username}@${var.node_ips[each.key]} "sudo $JOIN_CMD"
    EOF
  }
}
