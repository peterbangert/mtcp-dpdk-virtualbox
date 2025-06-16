#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
  source config.sh
fi

INTERFACE_NAME=dpdk0
IP="10.10.11.6"
NEXT_HOP_IP=10.10.11.5
NETMASK="255.255.255.0"
NEXT_HOP_MAC=""

#How is client configured? Change the following based on it.
CLIENT_IP_DOMAIN="10.10.10.0"
CLIENT_IP_NETMASK="255.255.255.0"

sudo ifconfig $INTERFACE_NAME $IP netmask $NETMASK up
sudo route add -net $CLIENT_IP_DOMAIN netmask $CLIENT_IP_NETMASK gw $NEXT_HOP_IP dev $INTERFACE_NAME
sudo arp -s $NEXT_HOP_IP $NEXT_HOP_MAC