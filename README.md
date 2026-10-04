# Libvirt Kubernetes Cluster

This is a fork from my [lab-libvirt-kubernetes](https://github.com/ChrisPJohnstone/lab-libvirt-kubernetes) project. That project provisions a cluster and actually deploys things to it, this project will just be to create a local cluster.

I'm not sure how much development I'll put in to it as there are far better technologies available like [minikube](https://minikube.sigs.k8s.io) & I could "play in production" by messing with my [homelab cluster](https://github.com/ChrisPJohnstone/homelab-terraform-proxmox) but it might be fun to make this project support different cluster tooling like

- Base systems
    - [x] [Debian](https://debian.org) / systemd
    - [ ] Non systemd linux e.g. [Void](https://voidlinux.org/)
    - [ ] [Talos](https://www.siderolabs.com/talos-linux)
- Container runtimes
    - [x] [containerd](https://containerd.io/)
    - [ ] [cri-o](https://cri-o.io/)
- Container Network Interfaces (CNI)
    - [x] [flannel](https://github.com/flannel-io/flannel)
- Bootstrapping tools
    - [x] [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/)

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
- An SSH key pair on your system

### Updating Variables

> [!NOTE]
> This step is optional, you only need to update variables if the [defaults](./terraform/variables.tf) do not work for you.
>
> For example:
>
> - Changing the `guest_username` to match your own
> - Changing your `ssh_key_path`
> - Changing `kubeconfig_path` - if you output to `~/.kube/config` you can run `kubectl` commands without specifying the `KUBECONFIG` environment variable
> - Changing number of workers
> - Changing IP adddresses of workers

- Copy [`terraform/.auto.tfvars.dist`](./terraform/.auto.tfvars.dist) to `terraform/.auto.tfvars`
    ```sh
    cp terraform/.auto.tfvars.dist terraform/.auto.tfvars
    ```
- Update the values in `terraform/.auto.tfvars`

### Managing Resources

> [!NOTE]
> All commands should be run from [terraform](./terraform/) directory
>
> - If you are using a passphrase protected SSH key you need to use [ssh-agent](https://www.man7.org/linux/man-pages/man1/ssh-agent.1.html) and ensure you've `ssh-add`'ed to your current session before deploying

- Deploy Resources
    ```sh
    terraform apply
    ```
- Destroy Resources
    ```sh
    terraform destroy
    ```

### Managing Cluster

Once you've deployed the cluster you should find the `kubeconfig` at the root of the repository. If you want to change where the kubeconfig is put you can update [`kubeconfig_path` variable](./terraform/variables.tf)

An example of how you can interact with the cluster using [kubectl](https://kubernetes.io/docs/reference/kubectl/)

```sh
KUBECONFIG=./kubeconfig kubectl get pods -A
```

### Managing Nodes

All of the nodes will be set up for SSH based on your configured [variables](./terraform/variables.tf)

```sh
ssh {guest_username}@{guest_ip}
```

Example

```sh
ssh chris@192.168.122.10
```
