#!/bin/bash
export DIR=$(pwd)
export SCRIPTS=$DIR/scripts

sudo apt install bc libgmp3-dev autotools-dev build-essential librdmacm-dev libnuma-dev libmnl-dev


# Clone the mTCP repository if it doesn't exist
if [ ! -d "$DIR/mtcp" ]; then
    git clone https://github.com/mtcp-stack/mtcp
    cd mtcp
    git submodule init
    git submodule update

$DIR/scripts/apply-dpdk-mtcp-patch.sh
$DIR/scripts/install-dpdk.sh
$DIR/scripts/install-mtcp.sh

echo "Take a look at setup-perf-client.sh and setup-perf-receiver.sh scripts in $SCRIPTS to configure perf client and receiver."