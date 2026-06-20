resource "libvirt_volume" "guest_volume" {
  name   = "${var.guest_name}-volume.qcow2"
  pool   = var.pool_name
  source = var.volume_source
  format = "qcow2"
}

resource "libvirt_cloudinit_disk" "guest_seed" {
  name           = "${var.guest_name}-cloudinit.iso"
  pool           = var.pool_name
  user_data      = <<-EOF
    #cloud-config
    disable_root: true
    users:
      - name: ${var.guest_username}
        ssh_authorized_keys:
          - ${var.ssh_public_key}
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
    bootcmd:
      - mkdir -p ${var.apt_key_dir}
      - curl -fsSLo ${var.apt_key_dir}k8s-key.gpg https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key
      - curl -fsSLo ${var.apt_key_dir}docker.gpg https://download.docker.com/linux/debian/gpg
    apt:
      sources:
        kubernetes:
          source: "deb [signed-by=${var.apt_key_dir}k8s-key.gpg] https://pkgs.k8s.io/core:/stable:/v1.36/deb/ /"
        docker:
          source: "deb [signed-by=${var.apt_key_dir}docker.gpg] https://download.docker.com/linux/debian bookworm stable"
      package_update: true
    packages:
      - apt-transport-https
      - ca-certificates
      - containerd.io
      - curl
      - gpg
      - kubeadm
      - kubectl
      - kubelet
    runcmd:
      # Disable Swap
      - swapoff -a
      - sed -i '/ swap / s/^/#/' /etc/fstab

      # Enable IP Forwarding
      - echo 'net.ipv4.ip_forward=1' | sudo tee /etc/sysctl.d/99-kubernetes.conf
      - sudo sysctl --system

      # Enable Containerd
      - sudo apt-mark hold containerd.io
      - containerd config default | sudo tee /etc/containerd/config.toml
      - sudo systemctl stop containerd # Requires restart for config to take effect
      - sudo systemctl enable --now containerd

      # Enable Kubelet
      - sudo apt-mark hold kubelet
      - sudo systemctl enable --now kubelet
  EOF
  meta_data      = <<-EOF
    instance-id: ${var.guest_name}
    local-hostname: ${var.guest_name}
  EOF
}

resource "libvirt_domain" "guest" {
  name      = var.guest_name
  type      = var.guest_type
  memory    = var.memory
  vcpu      = var.vcpu
  running   = var.running
  arch      = var.os_arch
  machine   = var.os_machine
  cloudinit = libvirt_cloudinit_disk.guest_seed.id

  boot_device {
    dev = ["hd"]
  }

  disk {
    volume_id = libvirt_volume.guest_volume.id
  }

  network_interface {
    network_name   = var.network_interface
    wait_for_lease = true
  }

  console {
    type        = var.console_type
    target_port = var.console_target_port
  }
}
