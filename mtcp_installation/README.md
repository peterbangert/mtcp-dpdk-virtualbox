# Install and Test mTCP

This guide explains how to install and configure mTCP with DPDK support on your virtual machines. mTCP is a highly scalable user-level TCP stack for multicore systems, optimized for use with DPDK (Data Plane Development Kit).

## Prerequisites

Before starting the installation, ensure:
- You have completed the testbed setup from `testbed_installation`
- Both DPDK VMs are running and accessible
- You have root/sudo access on both VMs

## Installation Steps

### 1. Initial Setup

Run `setup.sh` on both DPDK Virtual Machines:

```bash
./setup.sh
```

This script performs the following essential tasks:
- Installs required system dependencies (libgmp3-dev, autotools-dev, etc.)
- Clones the mTCP repository and its submodules
- Applies necessary patches for DPDK compatibility
- Installs DPDK with proper configurations
- Installs mTCP with DPDK support

Note: 

- `./install-dpdk.sh`
	- This script assumes that your target is "x86_64-native-linuxapp-gcc". If not, change `$RTE_TARGET` accordingly.
- `./install-mtcp.sh`
	- This script also assumes that your target is "x86_64-native-linuxapp-gcc". If not, change `$RTE_TARGET` accordingly.

	- In case `./configure` fails and reports issues with `aclocal-1-x` please run within the `/mtcp` directory:
	```
	autoreconf -ivf
	```

### 2. Configure mTCP with DPDK

After the setup script completes successfully, configure mTCP by running:

```bash
./setup_mtcp_dpdk_env.sh
```

Follow these options in order:
1. Select option 15 (Insert igb_uio module)
2. Select option 18 (Setup VFIO permissions)
3. Select option 22 and enter '64' (Setup hugepages)
4. Select option 24 and enter your NIC PCI address (typically '0000:00:08.0')
5. Select option 35 (Exit)

The options above:
- Load the required kernel module
- Set up hugepages for DPDK memory management
- Bind your network interface to DPDK
- Configure proper permissions

### 3. Configure Network Interfaces

Run the appropriate setup script on each VM:

On DPDK1:
```bash
./setup-dpdk1.sh
```

On DPDK2:
```bash
./setup-dpdk2.sh
```

These scripts configure the DPDK interfaces with the correct IP addresses and routing tables for the testbed environment.

### 4. Final Configuration

On both VMs, run:
```bash
./configure --with-dpdk-lib=$RTE_SDK/$RTE_TARGET CFLAGS="-DMAX_CPUS=1"
make
```

This configures mTCP with DPDK support and compiles the stack.

## Verification

To verify your installation:
1. Check hugepages are allocated:
   ```bash
   cat /proc/meminfo | grep Huge
   ```
2. Verify DPDK interface is bound:
   ```bash
   dpdk-devbind.py --status
   ```
3. Check network connectivity between VMs





