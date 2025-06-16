# Setup Testbed

<p align="center">
  <img src="./img/testbed.png" />
</p>


## Prerequisite

Please install VirtualBox on your Host Machine before starting

- [VirtualBox Linux Downloads](https://www.virtualbox.org/wiki/Linux_Downloads)

## Setup Scripts

This directory contains four important setup scripts that automate the creation and configuration of the DPDK testbed environment. These scripts should be run in the specified order to set up the complete testbed.

### setup-virtualbox-vms.sh

This script automates the creation and initial configuration of the VirtualBox VMs needed for the testbed. It:
- Downloads Ubuntu Server ISO if not present
- Creates three VMs (dpdk1, dpdk2, and router) with:
  - 2 CPU cores each
  - 2GB RAM
  - 20GB disk space
  - Appropriate network adapters
- Configures NAT networking and internal networks
- Sets up the basic VM configuration

Usage:
```bash
./setup-virtualbox-vms.sh
```

Note: After running this script, you'll need to manually complete the Ubuntu installation on each VM using the downloaded ISO.

### setup-router.sh

This script configures the router VM to enable packet forwarding between the two DPDK VMs. It:
- Installs necessary networking tools
- Enables IP forwarding in the system
- Makes IP forwarding persistent across reboots

Usage:
```bash
sudo ./setup-router.sh
```

### setup-dpdk1.sh

This script configures the first DPDK VM (VM1) by:
- Installing required networking packages
- Creating and configuring the DPDK interface (dpdk0) with IP 10.10.10.4
- Setting up routing to reach the second network (10.10.11.0/24) through the router

Usage:
```bash
sudo ./setup-dpdk1.sh
```

### setup-dpdk2.sh

This script configures the second DPDK VM (VM2) by:
- Installing required networking packages
- Creating and configuring the DPDK interface (dpdk0) with IP 10.10.11.6
- Setting up routing to reach the first network (10.10.10.0/24) through the router

Usage:
```bash
sudo ./setup-dpdk2.sh
```

## Setup Order

1. First, run `setup-virtualbox-vms.sh` to create and configure the VMs
2. Complete the Ubuntu installation on all three VMs
3. Run `setup-router.sh` on the router VM to enable packet forwarding
4. Run `setup-dpdk1.sh` on VM1
5. Run `setup-dpdk2.sh` on VM2

After running these scripts, the testbed will be configured with:
- VM1: DPDK interface at 10.10.10.4
- Router: Interfaces at 10.10.10.5 and 10.10.11.5
- VM2: DPDK interface at 10.10.11.6

The network will be fully configured for DPDK communication between VM1 and VM2 through the router.

## Prerequisites

Before running these scripts, ensure you have:
- VirtualBox installed on your host machine
- Sufficient disk space (at least 60GB free for all VMs)
- At least 8GB RAM on your host machine
- Hardware virtualization support enabled in BIOS/UEFI
- Administrator/sudo privileges

## Environment Check

You can verify your setup with these commands after running all scripts:
```bash
# On VM1
ping 10.10.11.6  # Should reach VM2
ip route show    # Should show route to 10.10.11.0/24 via router

# On VM2
ping 10.10.10.4  # Should reach VM1
ip route show    # Should show route to 10.10.10.0/24 via router

# On Router
ip route show    # Should show both networks
sysctl net.ipv4.ip_forward  # Should show 1
```

#### Next Steps

