# Infrastructure Management using Ansible

This directory contains the Ansible configuration to manage the homelab infrastructure.

## High Level Overview

The code in this directory manages:

**Static Infrastructure**
- 4 RaspberryPi Model 3b+ running latest DietPi
- 2 Baremetal servers running Ubuntu server 24.04

**Dynamic Infrastructure**
- KVM-based virtual machines running on the baremetal servers (Bridged/NAT networking)
- KVM-based virtual machines running on the laptop (NAT networking)

## Prerequisites

The control node is a personal laptop, we will refer to as `control-laptop`. Ansibel is installed on the control-laptop and operates in the push mode to manage the Static and Dynamic infrastructure mentioned above.

### 1. Managed Node Pre-requisites
Each node that is to be managed by Ansible must have the `ansible` user created and have the SSH keys added to the `authorized_keys` file. This is done by running the `bootstrap/bootstrap-ansible-user.yml` playbook, explained in detail in section 5 below.

However for the bootstrap process we need to have below pre-requisites on the managed node
- ssh server (OpenSSH running)
- an existing user with sudo access which is used to bootstrap the `ansible` user
- python3 and pip3 installed for ansible to run

These are setup manually on the managed nodes and are not part of the bootstrap process.

### 2. Install Ansible (on control-laptop)
Follow the instructions in the [official Ansible documentation](https://docs.ansible.com/projects/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu) to install Ansible on your control-laptop (which runs Ubuntu 24.04 in my case). 

### 3. Create SSH Keys (on control-laptop)
Generate an SSH keypair on your control node (where you run Ansible from) if you haven't already. 

```bash
mkdir -p ~/.ssh/ansible
ssh-keygen -t ed25519 -f ~/.ssh/ansible/id_ed25519
```

This will create `~/.ssh/ansible/id_ed25519` (private key) and `~/.ssh/ansible/id_ed25519.pub` (public key) in the `~/.ssh/ansible/` directory. The public key is added as the authorized key for the `ansible` user on all nodes.

The authorized key file format explains the setup of [options that can be used to add additional restrictions to the SSH connection](https://man.openbsd.org/OpenBSD-current/man8/sshd.8#AUTHORIZED_KEYS_FILE_FORMAT)

Edit the public key `~/.ssh/ansible/id_ed25519.pub` and add the `from="comma separated list of IP addresses",no-pty,no-agent-forwarding,no-X11-forwarding` option to the beginning of the line. This will   
- restrict the SSH connection for the `ansible` user from only the IP addresses specified in the list
- `no-pty` option will prevent the user from running interactive commands
- `no-agent-forwarding` and `no-X11-forwarding` options will prevent the user from forwarding agent and X11 connections.

The `ansible` user will only be used to run Ansible playbooks on the managed nodes. It will be prevented from running any interactive commands on the managed nodes.

### 4. Create Ansible inventory file (on control-laptop)
Create an inventory file `hosts.yml` in the `infra/ansible/inventories/homelab` directory. This file will contain the list of all managed nodes. Example shown below:

```yaml
all:
  children:
    supermicro:
      hosts:
        dl14:
          ansible_host: 192.168.1.11  # Replace with actual IP
    rpi:
      hosts:
        rpi-node1:
          ansible_host: 192.168.1.20  # Replace with actual IP
    dynamic:
      hosts:
        # Dynamic KVM hosts will be listed here
```

### 5. Create Ansible User on the managed nodes
On the control-laptop, run the `bootstrap/bootstrap-ansible-user.yml` playbook to create the `ansible` users on all the RPi nodes. The below example shows bootstraping the `ansible` user on the RPi nodes. The `--limit` option is used to limit the playbook to only run on all the RPi nodes, but can be used to limit to a specific node too using the node name, e.g. `--limit rpi-node1`.

```bash
ansible-playbook -i inventories/homelab/hosts.yml \
bootstrap/bootstrap-ansible-user.yml \
-e ansible_user=hemen \
-e ansible_ssh_private_key_file=~/.ssh/RPi/id_ed25519_hemen \
--limit rpi \
--ask-become-pass
```
Similary run the playbook for the supermicro nodes as well updating the limit to `supermicro` and the private key to the supermicro private key.

### 6. Managing the Infrastructure
After bootstrapping the nodes with the `ansible` user, use the playbooks located in the `playbooks/` directory to consistently configure and manage your homelab hosts.

The `playbooks/homelab-base.yml` playbook is the primary entrypoint for your infrastructure configuration. It applies base configurations to all hosts, as well as role-specific configurations (like `kvm_host` for your Supermicro servers).

To execute the site playbook across all managed nodes:

```bash
ansible-playbook -i inventories/homelab/hosts.yml playbooks/homelab-base.yml
```

You can target specific groups or individual nodes using the `--limit` argument:

```bash
# Target only the Raspberry Pi cluster
ansible-playbook -i inventories/homelab/hosts.yml playbooks/homelab-base.yml --limit rpi

# Target only a specific Raspberry Pi node
ansible-playbook -i inventories/homelab/hosts.yml playbooks/homelab-base.yml --limit rpi-node1

# Target only the baremetal Supermicro servers
ansible-playbook -i inventories/homelab/hosts.yml playbooks/homelab-base.yml --limit supermicro
```

#### User Environment & Dotfiles (Chezmoi Playbook)
To set up your user environment across your managed nodes, use the `playbooks/chezmoi.yml` playbook. This playbook installs the `chezmoi` binary to the `~/.local/bin` directory and automatically initializes your dotfiles repository.

Run the playbook with:

```bash
ansible-playbook -i inventories/homelab/hosts.yml playbooks/chezmoi.yml
```
