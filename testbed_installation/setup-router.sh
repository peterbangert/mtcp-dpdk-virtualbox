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

# Enable IP forwarding
# Ensure that IP forwarding is enabled in the system
sudo sysctl -w net.ipv4.ip_forward=1

# Make the change persistent across reboots
# Remove any existing line for net.ipv4.ip_forward and add the new one
sudo sed -i '/^net\.ipv4\.ip_forward=/d' /etc/sysctl.conf && echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Define the network configuration to be added
network_config="

auto enp0s8
iface enp0s8 inet static
   address 10.10.10.5
   netmask 255.255.255.0

auto enp0s9
iface enp0s9 inet static
   address 10.10.11.5
   netmask 255.255.255.0
"

# Append the network configuration to /etc/network/interfaces
echo "$network_config" | sudo tee -a /etc/network/interfaces > /dev/null

# Notify the user
echo "Network configuration has been added to /etc/network/interfaces."

# Allow Machine ID regeneration
sudo rm /etc/machine-id
sudo systemd-machine-id-setup