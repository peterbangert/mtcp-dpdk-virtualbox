#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
	source config.sh
fi
export RTE_SDK="$DIR/mtcp/dpdk"
export RTE_TARGET="x86_64-native-linuxapp-gcc"
cd $RTE_SDK
make install T=$RTE_TARGET
echo -e "\n"
echo "#####################"
echo "If make did not throw any errors, you may now proceed..."
echo "Install mtcp by running apply-powertcp-patch.sh and then install-mtcp.sh"
echo "#####################"
