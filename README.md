# Kubernetes Experiment

## Pre-Requisites

- Installed
    - [terraform](https://www.hashicorp.com/en/products/terraform)
    - [qemu](https://www.qemu.org/)
    - [libvirt](https://libvirt.org/)
- Running
    - `libvirtd`
    - `virtlogd`

## Usage

- `terraform -chdir=terraform init` Initialises terraform working directory
- `terraform -chdir=terraform apply` Creates resources
- `virsh list` Get a list of virtual machines
- `virsh domifaddr {name}` Get IP of virtual machine
- `ssh chris@{ip}` SSH in to VM

## Documentation

- [editorconfig](https://editorconfig.org/)
- [terraform](https://www.hashicorp.com/en/products/terraform)
- [qemu](https://www.qemu.org/)
- [libvirt](https://libvirt.org/)
- [terraform libvirt provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs)
