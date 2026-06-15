# Kubernetes Experiment

## Technology

- [KVM](https://linux-kvm.org/page/Main_Page) — Kernel-based virtual machine; provides hardware-accelerated virtualization on the Linux host
- [QEMU](https://www.qemu.org/) — Full system emulator; emulates devices (disk, network, serial) for each VM
- [libvirt](https://libvirt.org/) — Daemon and API that manages the QEMU/KVM lifecycle; handles domain creation, networking, and storage
- [Terraform](https://developer.hashicorp.com/terraform) — Declarative Infrastructure-as-Code; defines VMs, storage pools, and networking in `.tf` files
    - [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) — Terraform plugin that enables management of libvirt resources through Terraform
- [Debian](https://cloud.debian.org/images/cloud/trixie/latest/) (cloud image) — Minimal Debian image with Cloud-Init support, used as the OS for every VM
- [Cloud-Init](https://cloud-init.io/) — Injects SSH keys, user accounts, and network settings into each VM on its initial boot

Three VMs are provisioned: `control_plane`, `doddit` and `hoddit`. Each VM uses a root volume backed by a qcow2 image, a Cloud-Init seed disk for first-boot configuration, and is attached to the libvirt default network (DHCP with lease-based IP assignment). VM addresses are exported as Terraform outputs.

## Pre-Requisites

- Project leverages [KVM](https://linux-kvm.org/page/Main_Page) so will only work on Linux
- Ensure dependencies installed
    - [Terraform](https://developer.hashicorp.com/terraform)
    - [QEMU](https://www.qemu.org/)
    - [libvirt](https://libvirt.org/)
- Ensure daemons running
    - `libvirtd`
    - `virtlogd`
