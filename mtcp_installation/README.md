# Install and Test mTCP


## Installation

1. Run `setup.sh` on both DPDK Virtual Machine

`./setup.sh`


This script will

- Install necessary libraries
- Clone MTCP repository
- Apply a necessary patch
- Install DPDK
- Insatll mTCP


2. Compile mTCP

After `setup.sh` has run successfully, please compile mTCP

```
./setup_mtcp_dpdk_env.sh
option 15
option 18
option 22 Type 64
option 24 Type 0000:00:08.0
option 35
```

3. Run setup scripts for each DPDK Virtual Machine

On the setup on each respective VM

```
./setup-dpdk{1,2}.sh
```

3. Setup nics

 - On Both

```
./configure --with-dpdk-lib=$RTE_SDK/$RTE_TARGET CFLAGS="-DMAX_CPUS=1"
make
```



### Debug Description

- The installation process can be done in one shot by running `./setup.sh`. Otherwise, follow the step by step procedure below.
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

- After successfully running the above script, you can now run `mtcp/setup_mtcp_dpdk_env.sh`
	- Since step 4. already compiled and installed DPDK, you can select exit first
	- Insert igb_uio
	- bind relevant network devices to igb_uio (Note: You should set the interfaces down with ifconfig first)
	- Setup hugepages (eg., 8096 with 2MB hugepages or 16 with 1G hugepages)
	- Setup VFIO permissions
	- Exit now and the mtcp setup script will continue.





