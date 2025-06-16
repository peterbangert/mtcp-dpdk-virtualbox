
# Test DPDK

> Install and run DPDK and examples alone without MTCP framework

### Install DPDK

- Install via package manager (quickest, recommended)
   
   ```
   sudo apt install dpdk-dev
   ```

 - Install/Compile DPDK manually

   ```
    wget http://fast.dpdk.org/rel/dpdk-22.03.tar.xz
    tar xf dpdk.tar.gz
    sudo apt-get install -y build-essential librdmacm-dev libnuma-dev libmnl-dev \ 
    meson python3-pip pkg-config
    sudo pip install pyelftools
    sudo apt update upgrade
    sudo meson build
    sudo ninja -C build
    ```

### Setup Hugepages


   ```
   mkdir -p /dev/hugepages
   mountpoint -q /dev/hugepages || mount -t hugetlbfs nodev /dev/hugepages
   echo 64 > /sys/devices/system/node/node0/hugepages/hugepages-2048kB/nr_hugepages
   ```


### Run testpmd example


1. Get PCI of interface (bus info)
   ```
   ethtool -i <iface>
   ```

2. Run dual port testpmd application

   ```
   sudo dpdk-testpmd -w 0000:00:08.0 -w 0000:00:09.0 \ 
   --vdev="net_pcap0,iface=enp0s8" --vdev="net_pcap1,iface=enp0s9" \ 
   -- -i --total-num-mbufs=2048

   testpmd> show port stats all

   ######################## NIC statistics for port 0  ########################
   RX-packets: 0          RX-errors: 0         RX-bytes: 0
   TX-packets: 0          TX-errors: 0         TX-bytes: 0
   ############################################################################

   ######################## NIC statistics for port 1  ########################
   RX-packets: 0          RX-errors: 0         RX-bytes: 0
   TX-packets: 0          TX-errors: 0         TX-bytes: 0
   ############################################################################

   testpmd> start tx_first

   testpmd> stop

   ```

3. Run Sender/Reciever Test Application 

   TX Side

   ```
   sudo dpdk-testpmd \
   -w 0000:00:08.0 \
   --vdev="net_pcap0,iface=enp0s8" \
   -- --port-topology=chained \
   --forward-mode=txonly \
   --eth-peer=0,08:00:27:df:80:4e\
   --total-num-mbufs=2048 \
   --stats-period 2
   ```

   RX Side

   ```
   sudo dpdk-testpmd \
   -w 0000:00:08.0 \
   --vdev="net_pcap0,iface=enp0s8" \
   -- --port-topology=chained \
   --forward-mode=rxonly \
   --eth-peer=0,08:00:27:7b:57:ee \
   --total-num-mbufs=2048 \
   --stats-period 2
   ```

   Results

   ```
   Port statistics ====================================
   ######################## NIC statistics for port 0  ########################
   RX-packets: 0          RX-missed: 0          RX-bytes:  0
   RX-errors: 0
   RX-nombuf:  0         
   TX-packets: 1545248    TX-errors: 0          TX-bytes:  98895872

   Throughput (since last show)
   Rx-pps:            0          Rx-bps:            0
   Tx-pps:        39374          Tx-bps:     20159752
   ############################################################################
   ```

   ```
   Port statistics ====================================
   ######################## NIC statistics for port 0  ########################
   RX-packets: 2110464    RX-missed: 0          RX-bytes:  135070498
   RX-errors: 0
   RX-nombuf:  0         
   TX-packets: 0          TX-errors: 0          TX-bytes:  0

   Throughput (since last show)
   Rx-pps:        42365          Rx-bps:     21691144
   Tx-pps:            0          Tx-bps:            0
   ############################################################################
   ```