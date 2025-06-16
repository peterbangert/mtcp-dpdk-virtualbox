#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
	source config.sh
fi
export RTE_SDK="$MTCP_DIR/mtcp/dpdk"
export RTE_TARGET="x86_64-native-linuxapp-gcc"
export MTCP="$MTCP_DIR/mtcp"
cd $MTCP
CFLAGS="-w -fcommon" ./configure --with-dpdk-lib=$RTE_SDK/$RTE_TARGET
make
cd apps/perf
make 
cd $MTCP/../
echo -e "\n"
echo "#####################"
echo "If make did not throw any errors, Congratuations!!!"
echo "Now run mtcp/setup_mtcp_dpdk_env.sh to finish setting up your dpdk interfaces."
echo "Check README.md for more details on what to do within setup_mtcp_dpdk_env.sh"
echo "#####################"
