#!/bin/bash
export DIR=$(pwd)
export SCRIPTS=$DIR/scripts

$DIR/scripts/apply-dpdk-mtcp-patch.sh
$DIR/scripts/apply-powertcp-patch.sh
$DIR/scripts/install-dpdk.sh
$DIR/scripts/install-mtcp.sh

echo "Take a look at setup-perf-client.sh and setup-perf-receiver.sh scripts in $SCRIPTS to configure perf client and receiver."