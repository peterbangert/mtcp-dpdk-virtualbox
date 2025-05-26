# MTCP on DPDK in VirtualBox

## Current Status

- Setting up required modules (mtcp + DPDK) works well on Ubuntu 22 and Kernel 5.15
- mtcp reaches 15Gbps approx with single core
- [ToDo] Optimize DPDK parameters and system configurations to saturate 25Gbps link
- [ToDo] PowerTCP congestion control logic to be integrated soon after initial testing
- [ToDo] Create a new perf client that continuously generates flows based on a flow size distribution

## Installation
1. Clone this repository. The best way is to use `recurse-submodules` tag.
```bash
git clone --recurse-submodules git@github.com:inet-tub/PowerTCP-KernelBypass.git
cd PowerTCP-KernelBypass # changing directory to root of this repository
```
2. *[Skip if you followed 1.]* If you already cloned this repository without `recurse-submodules` tag, then use the following commands:
	```bash
	git clone git@github.com:inet-tub/PowerTCP-KernelBypass.git
	cd PowerTCP-KernelBypass/mtcp
	git submodule init
	git submodule update
	cd dpdk
	git submodule init
	git submodule update
	# Custom versions of DPDK are not supported yet by the mtcp developers! 
	# You might have to deal with compilation errors.
	git checkout <commithash> 
	cd ./../../
	```
3. The installation process can be done in one shot by running `./setup.sh`. Otherwise, follow the step by step procedure below.
	- Change directory `cd scripts/`
	- Apply the patch by running `./apply-dpdk-mtcp-patch.sh`
	- Install DPDK by running `./install-dpdk.sh`
		- This script assumes that your target is "x86_64-native-linuxapp-gcc". If not, change `$RTE_TARGET` accordingly.
	- Install mtcp by running `./install-mtcp.sh`
		- This script also assumes that your target is "x86_64-native-linuxapp-gcc". If not, change `$RTE_TARGET` accordingly.

		- In case `./configure` fails and reports issues with `aclocal-1-x` please run within the `/mtcp` directory:
		```
		autoreconf -ivf
		```

6. After successfully running the above script, you can now run `mtcp/setup_mtcp_dpdk_env.sh`
	- Since step 4. already compiled and installed DPDK, you can select exit first
	- Insert igb_uio
	- bind relevant network devices to igb_uio (Note: You should set the interfaces down with ifconfig first)
	- Setup hugepages (eg., 8096 with 2MB hugepages or 16 with 1G hugepages)
	- Setup VFIO permissions
	- Exit now and the mtcp setup script will continue.

## Tested Environments

1. Kernel - 5.15.0-52-generic; gcc version 11.3.0 (Ubuntu 11.3.0-1ubuntu1~22.04)
2. Kernel - 4.4.0-186-generic; gcc version 5.4.0 (Ubuntu 5.4.0-6ubuntu1~16.04.12)


## Contact Us

```
Peter Bangert - petbangert@gmail.com
```