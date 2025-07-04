#!/bin/bash

# Configuration Variables
ISO_PATH="./ubuntu-24.04.2-live-server-amd64.iso"  # Path to the ISO file
VMS=("dpdk1" "dpdk2" "router")
OSTYPE="Ubuntu_64"  # Change this to match your OS type
DISK_SIZE="20000"   # Size in MB (20GB)
RAM_SIZE="2048"     # Size in MB (2GB)
VCPU_COUNT="2"      # Number of CPU cores
VRAM_SIZE="128"     # Size in MB
NAT_NETWORK_NAME="NatNetwork"  # Name of the NAT network

# This script sets up VirtualBox VMs for a testbed environment with DPDK and OVS.
# Ensure VirtualBox is installed
if ! command -v VBoxManage &> /dev/null; then
    echo "VirtualBox is not installed. Please install VirtualBox and try again."
    exit 1
fi

# Define the URL and the expected file name
URL="https://ftp.halifax.rwth-aachen.de/ubuntu-releases/24.04/ubuntu-24.04.2-live-server-amd64.iso"

# Check if the file already exists
if [[ -e "$ISO_PATH" ]]; then
    echo "The file '$EXPECTED_FILENAME' already exists in the current directory."
else
    echo "Downloading the ISO file..."
    curl -o "$ISO_PATH" "$URL"
fi

## VirtualBox Network Configuration
# Configure Subnets for each DPDK VM
vboxmanage dhcpserver add --netname subnet_dpdk1 --ip 10.10.10.1 --netmask 255.255.255.0 --lowerip 10.10.10.2 --upperip 10.10.10.212 --enable 
vboxmanage dhcpserver add --netname subnet_dpdk2 --ip 10.10.11.1 --netmask 255.255.255.0 --lowerip 10.10.11.2 --upperip 10.10.11.212 --enable

# Create NAT network for port forwarding
VBoxManage natnetwork add --netname NatNetwork --network "10.0.2.0/24" --enable
VBoxManage natnetwork modify --netname NatNetwork --dhcp on
VBoxManage natnetwork modify --netname NatNetwork --port-forward-4 "rule1:tcp:[127.0.0.1]:2224:[10.0.2.4]:22"
VBoxManage natnetwork modify --netname NatNetwork --port-forward-4 "rule2:tcp:[127.0.0.1]:2225:[10.0.2.5]:22"
VBoxManage natnetwork modify --netname NatNetwork --port-forward-4 "rule3:tcp:[127.0.0.1]:2226:[10.0.2.6]:22"


# Create virtual machines
create_vm() {
    local VM_NAME=$1
    local VM_PATH="$HOME/VirtualBox VMs/$VM_NAME"
    
    # Create VM
    VBoxManage createvm --name "$VM_NAME" --ostype "$OSTYPE" --register

    # Modify VM settings
    VBoxManage modifyvm "$VM_NAME" --memory "$RAM_SIZE" --vram "$VRAM_SIZE" --acpi on --boot1 dvd --nic1 nat --cpus "$VCPU_COUNT"

    # Create a virtual hard disk
    VBoxManage createhd --filename "$VM_PATH/$VM_NAME.vdi" --size "$DISK_SIZE"

    # Add a SATA controller
    VBoxManage storagectl "$VM_NAME" --name "SATA Controller" --add sata --controller IntelAhci

    # Attach the virtual hard disk to the SATA controller
    VBoxManage storageattach "$VM_NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$VM_PATH/$VM_NAME.vdi"

    # Add an IDE controller for the ISO
    VBoxManage storagectl "$VM_NAME" --name "IDE Controller" --add ide

    # Attach the ISO to the IDE controller
    VBoxManage storageattach "$VM_NAME" --storagectl "IDE Controller" --port 0 --device 0 --type dvddrive --medium "$ISO_PATH"

    # Connect the first network adapter to the NAT network
    VBoxManage modifyvm "$VM_NAME" --nic1 natnetwork --nat-network1 "$NAT_NETWORK_NAME"

    if [ "$VM_NAME" == "router" ]; then
        VBoxManage modifyvm "$VM_NAME" --nic2 intnet --intnet2 "subnet_dpdk1"
        VBoxManage modifyvm "$VM_NAME" --nic3 intnet --intnet3 "subnet_dpdk2"
    else
        # Enable the second network adapter and attach to the specified internal network
        VBoxManage modifyvm "$VM_NAME" --nic2 intnet --intnet2 "subnet_$VM_NAME"
    fi

    echo "Virtual machine '$VM_NAME' has been created and configured."
}

# Loop through each VM name and create each VM
for VM_NAME in "${VMS[@]}"; do
    create_vm "$VM_NAME"
done

echo "All virtual machines have been created and configured."