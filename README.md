# Kubernetes Lab

This project exists for me to experiment, primarily with virtual machines and Kubernetes.

The [chosen technologies](#technology) were made to prioritise **learning** by minimising the "magic" that happens behind the scenes.

Some alternatives that would probably make life easier
- [minikube](https://minikube.sigs.k8s.io) instead of self-provisioning
- [VirtualBox](https://www.virtualbox.org/) instead of [libvirt](https://libvirt.org/)/[QEMU](https://www.qemu.org/)/[KVM](https://linux-kvm.org/page/Main_Page)
- [Talos](https://www.siderolabs.com/talos-linux) instead of [Debian](https://cloud.debian.org/images/cloud/trixie/latest/) & [Cloud-Init](https://cloud-init.io/)
- [Helm](https://helm.sh/) instead of [bespoke configs](./terraform/cluster/configs)

## Technology

- [Terraform](https://developer.hashicorp.com/terraform) - Declarative Infrastructure-as-Code
    - [Terraform libvirt Provider](https://registry.terraform.io/providers/dmacvicar/libvirt/latest/docs) - Terraform provider for managing libvirt resources
    - [Terraform Kubernetes Provider](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs) - Terraform provider for managing Kubernetes resources via the API
- [KVM](https://linux-kvm.org/page/Main_Page) - Linux kernel module for hardware-accelerated virtualization
- [QEMU](https://www.qemu.org/) - Machine emulator and virtualizer
- [libvirt](https://libvirt.org/) - Virtualization management API, daemon, and management tool
- [Cloud-Init](https://cloud-init.io/) - Cloud instance initialisation tool
- [Debian](https://cloud.debian.org/images/cloud/trixie/latest/) - Linux distribution
- [containerd](https://containerd.io/) - Container runtime
- [Kubernetes](https://kubernetes.io/) - Container orchestration platform for automating deployment, scaling, and management of containerized workloads
    - [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) - Kubernetes cluster bootstrapping tool
    - [flannel](https://github.com/flannel-io/flannel) - Kubernetes Container Network Interface (CNI)
- [Envoy Proxy](https://www.envoyproxy.io/) - L4/L7 Proxy
- [Envoy Gateway](https://gateway.envoyproxy.io/) - Kubernetes Gateway API Implementation
- [MetalLB](https://metallb.io/) - Bare-metal load balancer
- [Prometheus](https://prometheus.io/) - Monitoring & Alerting system
- [Grafana](https://grafana.com/) - Metrics Visualisation & Observability platform

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

- Deploy resources
    ```sh
    ./terraform/deploy
    ```
- Destroy resources
    ```sh
    ./terraform/destroy
    ```

## Roadmap

This section functions mostly as a todo list / note section for myself so it might not be very organised.

### Planned

- [x] Provision libvirt pool
- [x] Provision Debian VM's with Cloud-Init
    - [x] Static IP for VM's
    - [x] Create user
    - [x] Enable SSH access
    - [x] Disable Swap
    - [x] Enable IP Forwarding
    - [x] Install, configure & enable containerd
    - [x] Install & enable kubelet
    - [x] Initalise Cluster
    - [x] Set up pod network
    - [x] Connect Nodes
- [x] Extract kubeconfig
- [x] Deploy something (nginx)
- [x] Deploy Prometheus
    - [ ] Make address consistent
        - [ ] Ingress
        - [ ] Load Balancer
- [ ] Deploy Grafana
- Figure out something to deploy that covers cool scenarios (high availability, network security)

### Future

- Check how much reliance there is on systemd & consider switching away
- Update terraform libvirt provider version. Rolled back to v0.8.3 as rewrite (v0.9.8) had defect with CPU porivisioning on Debian.
- Might refactor `virtual_machine` to take `n_nodes` and name them automatigically but I like my silly names for now
