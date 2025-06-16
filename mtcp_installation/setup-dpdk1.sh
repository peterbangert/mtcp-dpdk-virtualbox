#!/usr/bin/env bash

## Run this script within the DPDK1 Virtual Machine (VM1)
sudo ifconfig dpdk0  10.10.10.4 netmask 255.255.255.0 up
export RTE_SDK=`echo $PWD`/mtcp/dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc
route add -net 10.10.11.0 netmask 255.255.255.0 gw 10.10.10.5 dev dpdk0

PERF_DIR="mtcp/apps/perf/config"
EPWGET_DIR="mtcp/apps/example/config"

if [ ! -d "$PERF_DIR" ]; then
  echo "$PERF_DIR does not exist."
  mkdir -p $PERF_DIR
fi

cat <<EOT > $PERF_DIR/arp.conf
ARP_ENTRY 2
# ARP Entries for VM1
10.10.10.5/32 08:00:27:40:1d:d9
10.10.11.6/32 08:00:27:40:1d:d9
EOT

cat <<EOT > $PERF_DIR/route.conf
ROUTES 2
# Route Entries for VM2
10.10.10.0/24 dpdk0
10.10.11.0/24 dpdk0
EOT

if [ ! -d "$EPWGET_DIR" ]; then
  echo "$EPWGET_DIR does not exist."
  mkdir -p $EPWGET_DIR
fi

cat <<EOT > $EPWGET_DIR/arp.conf
ARP_ENTRY 2
# ARP Entries for VM1
10.10.10.5/32 08:00:27:40:1d:d9
10.10.11.6/32 08:00:27:40:1d:d9
EOT

cat <<EOT > $EPWGET_DIR/route.conf
ROUTES 2
# Route Entries for VM2
10.10.10.0/24 dpdk0
10.10.11.0/24 dpdk0
EOT
