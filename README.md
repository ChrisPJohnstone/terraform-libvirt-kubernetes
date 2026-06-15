# Kubernetes Lab

This project exists for me to experiment, primarily with virtual machines and Kubernetes.

The [chosen technologies](#technology) were made to prioritise **learning** by minimising the "magic" that happens behind the scenes. Things like [minikube](https://minikube.sigs.k8s.io), [VirtualBox](https://www.virtualbox.org/) or even cloud providers would be far more sensible for pure kubernetes exposure.

## Technology

- [Terraform](https://developer.hashicorp.com/terraform) — Declarative Infrastructure-as-Code
    - [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) — Terraform provider for managing libvirt resources
    - [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) — Terraform provider for managing Kubernetes resources via the API
- [KVM](https://linux-kvm.org/page/Main_Page) — Linux kernel module for hardware-accelerated virtualization
- [QEMU](https://www.qemu.org/) — Machine emulator and virtualizer
- [libvirt](https://libvirt.org/) — Virtualization management API, daemon, and management tool
- [Cloud-Init](https://cloud-init.io/) — Cloud instance initialisation tool
- [Debian](https://cloud.debian.org/images/cloud/trixie/latest/) — Linux distribution
- [containerd](https://containerd.io/) — Container runtime
- [Kubernetes](https://kubernetes.io/) — Container orchestration platform for automating deployment, scaling, and management of containerized workloads
    - [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) — Kubernetes cluster bootstrapping tool

## Usage

### Prerequisites

- Project leverages [KVM](https://linux-kvm.org/page/Main_Page) so will only work on Linux
- Ensure dependencies installed
    - [Terraform](https://developer.hashicorp.com/terraform)
    - [QEMU](https://www.qemu.org/)
    - [libvirt](https://libvirt.org/)
- Ensure daemons running
    - `libvirtd`
    - `virtlogd`

### Managing Infrastructure

- Initialise Terraform (First time only)
    ```sh
    terraform -chdir=terraform init
    ```
- Deploy resources
    ```sh
    terraform -chdir=terraform apply
    ```
- Destroy resources
    ```sh
    terraform -chdir=terraform destroy
    ```

## Roadmap

- [x] Provision libvirt pool
- [ ] Provision Debian Virtual Machines
    - [x] Add IP to outputs
    - [ ] Configure worker nodes
        - [x] Create user
        - [x] Enable SSH access
        - [x] Disable Swap
        - [x] Install & enable kubelet
        - [ ] Configure cgroup
    - [ ] Configure Control Plane
        - [ ] Create user
        - [ ] Enable SSH access
        - [ ] Disable Swap
        - [ ] Install kubeadm
        - [ ] Initialise cluster
        - [ ] Join the worker nodes
    - [ ] Check how much reliance there is on systemd & consider switching away
- [ ] Start using kubernetes terraform
- [ ] Deploy... something
