#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
  source config.sh
fi

IP="10.10.10.4"
NETMASK="255.255.255.0"
INTERFACE_NAME="dpdk0"

sudo ifconfig $INTERFACE_NAME $IP netmask $NETMASK up
export RTE_SDK=$DIR/mtcp/dpdk
export RTE_TARGET=x86_64-native-linuxapp-gcc
# route add -net 10.10.11.0 netmask 255.255.255.0 gw 10.10.10.5 dev dpdk0

PERF_DIR="$DIR/mtcp/apps/perf/config"

if [ ! -d "$PERF_DIR" ]; then
  mkdir -p $PERF_DIR
fi

cat <<EOT > $PERF_DIR/arp.conf
ARP_ENTRY 1
# ARP Entries
192.168.8.3/32 40:a6:b7:21:fb:64
EOT

cat <<EOT > $PERF_DIR/route.conf
ROUTES 1
# Route Entries
192.168.8.3/0 dpdk0
EOT
