#!/bin/bash
set -euxo pipefail

# This script sets up the Router to allow for packet forwarding between two DPDK VMs.
# Ensure the script is run with root privileges
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root or use sudo."
    exit 1
fi
# Update the package list and install necessary packages
sudo apt-get update
sudo apt-get install -y net-tools iptables-persistent

# Create dpdk interface
sudo ifconfig dpdk0  10.10.11.6 netmask 255.255.255.0 up
route add -net 10.10.10.0 netmask 255.255.255.0 gw 10.10.11.5 dev dpdk0

# Allow Machine ID regeneration
sudo rm /etc/machine-id
sudo systemd-machine-id-setup