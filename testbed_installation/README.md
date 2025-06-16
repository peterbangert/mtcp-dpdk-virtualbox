# Setup Testbed

<p align="center">
  <img src="../img/testbed.png" />
</p>

## Virtualbox Setup

   1. Under Tools->Preferences->Network create a NAT Network

   This Nat Network allows for typical NATing for outbound connections but also allows internal connections between VMs and alows VMs to have unique IPs inside NAT network, easier for controlling from host machine. 

## VM Setup

   1. Two Ubuntu 16.04 headless server images

      Download: https://releases.ubuntu.com/16.04/ubuntu-16.04.7-server-amd64.iso

   2. Follow this guide for step by step setup of VMs
   
      Guide: https://blog.emumba.com/setting-up-virtual-machines-for-dpdk-da1b49a9bf5f


   3. Give 2VCPUs, 2GB RAM, 20-30GB hard disk.

   4. Run through installation setup

## Network config

   
   1. Internal Network adapter 1: subnet 10.10.10.X

```
vboxmanage dhcpserver add --netname intnet1 --ip 10.10.10.1 \ 
--netmask 255.255.255.0 --lowerip 10.10.10.2 --upperip 10.10.10.212 --enable
```

   2. Internal Network adapter 2: subnet 10.10.11.X

```
vboxmanage dhcpserver add --netname intnet2 --ip 10.10.11.1 \ 
--netmask 255.255.255.0 --lowerip 10.10.11.2 --upperip 10.10.11.212 --enable
```

   3. In VM1

   - Goto Settings->Network->Adapter 2
   - Enable Adapter 2, Attach to Internal Network
   - Set Name: intnet1

   4. In VM2 

   - Goto Settings->Network->Adapter 2
   - Enable Adapter 2, Attach to Internal Network
   - Set Name: intnet2

   5. In Router1

   - Attach Adapter 2,3 to internal networks 1,2 respectively
   - Start VM
   - Allow IP forwarding

   ```
   vim /etc/sysctl.conf
   > Uncomment or add this line:
   net.ipv4.ip_forward=1
   > exit
   sysctl -p
   ```

   - Add lines to `/etc/network/interfaces`

   ```
   auto enp0s8
   iface enp0s8 inet static
      address 10.10.10.5
      netmask 255.255.255.0
   
   auto enp0s9
   iface enp0s9 inet static
      address 10.10.11.5
      netmask 255.255.255.0
   ```


   5. Adjust VMs to have different IP addresses on main VNIC

```
sudo rm /etc/machine-id
sudo systemd-machine-id-setup
```

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

