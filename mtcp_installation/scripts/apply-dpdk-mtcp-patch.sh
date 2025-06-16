#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
	source config.sh
fi

export RTE_SDK="$MTCP_DIR/mtcp/dpdk"
export RTE_TARGET="x86_64-native-linuxapp-gcc"

KERNEL_VERSION=$(uname -r | awk -F "." '{print $1}')
echo "Kernel version starts with $KERNEL_VERSION"

if [[ $KERNEL_VERSION -eq 4 ]];then
	DPDK_CFLAGS[0]="WERROR_FLAGS += -w -fcommon"
else
	DPDK_CFLAGS[0]="WERROR_FLAGS += -Wno-error=misleading-indentation"
	DPDK_CFLAGS[1]="WERROR_FLAGS += -Wno-error=stringop-truncation"
	DPDK_CFLAGS[2]="WERROR_FLAGS += -Wno-error=stringop-overread"
	DPDK_CFLAGS[3]="WERROR_FLAGS += -Wno-error=address-of-packed-member"
	DPDK_CFLAGS[4]="WERROR_FLAGS += -Wno-format-truncation"
	DPDK_CFLAGS[5]="WERROR_FLAGS += -Wimplicit-fallthrough=0 -Wno-implicit-function-declaration -Wno-implicit-int -Wno-implicit-fallthrough"
	DPDK_CFLAGS[6]="WERROR_FLAGS += -Wno-incompatible-pointer-types"
	DPDK_CFLAGS[7]="WERROR_FLAGS += -w -fcommon"
fi

RTE_MK="$MTCP_DIR/mtcp/dpdk/mk/toolchain/gcc/rte.vars.mk"
echo "Editing $RTE_MK file..."
CHANGED=0
for line in "${DPDK_CFLAGS[@]}";do
        if [[ "$(grep --line-regexp "$line" "$RTE_MK")" ]];then
                echo "[FOUND] $(grep --line-regexp "$line" "$RTE_MK")"
        else
                echo "[APPENDING] $line to $RTE_MK"
                echo "$line" >> $RTE_MK
		CHANGED=$(( $CHANGED+1 ))
        fi
done
if [[ $CHANGED -eq 0 ]];then
	echo "$RTE_MK file is already in the desired state"
else
	echo "Modified $RTE_MK"
fi

echo -e "\n"
KERNEL_MK="$MTCP_DIR/mtcp/dpdk/kernel/linux/igb_uio/Makefile"
echo "Editing $KERNEL_MK file..."
line="MODULE_CFLAGS += -Winline -Wall -Werror"
newline="MODULE_CFLAGS += -Winline -Wall"
if [[ "$(grep --line-regexp "$line" "$KERNEL_MK")" ]];then
	echo "[ORIGINAL LINE] $line"
	echo "[NEW LINE] $newline"
	sed -i 's/MODULE_CFLAGS += -Winline -Wall -Werror/MODULE_CFLAGS += -Winline -Wall/g' $KERNEL_MK
	echo "Modified $KERNEL_MK"
else
	echo "$KERNEL_MK file is already in the desired state"
fi

echo -e "\n"
KERNEL_MK="$MTCP_DIR/mtcp/dpdk/kernel/linux/kni/Makefile"
echo "Editing $KERNEL_MK file..."
line="MODULE_CFLAGS += -Wall -Werror"
if [[ $KERNEL_VERSION -eq 4 ]];then
	newline="MODULE_CFLAGS += -Wall"
	if [[ "$(grep --line-regexp "$line" "$KERNEL_MK")" ]];then
	        echo "[ORIGINAL LINE] $line"
	        echo "[NEW LINE] $newline"
	        sed -i 's/MODULE_CFLAGS += -Wall -Werror/MODULE_CFLAGS += -Wall/g' $KERNEL_MK
		echo "Modified $KERNEL_MK"
	else
        	echo "$KERNEL_MK file is already in the desired state"
	fi
else
	newline="MODULE_CFLAGS += -Wall -Wno-incompatible-pointer-types"
	if [[ "$(grep --line-regexp "$line" "$KERNEL_MK")" ]];then
	        echo "[ORIGINAL LINE] $line"
	        echo "[NEW LINE] $newline"
	        sed -i 's/MODULE_CFLAGS += -Wall -Werror/MODULE_CFLAGS += -Wall -Wno-incompatible-pointer-types/g' $KERNEL_MK
		echo "Modified $KERNEL_MK"
	else
        	echo "$KERNEL_MK file is already in the desired state"
	fi

fi

echo -e "\n"
DPDK_IFACE="$DMTCP_DIRIR/mtcp/dpdk-iface-kmod/dpdk_iface.h"
echo "Editing $DPDK_IFACE..."
if [[ $KERNEL_VERSION -eq 4 ]];then
	echo "nothing to do in $DPDK_IFACE"
else
	cp $DIR/scripts/mtcp-dpdk-iface-patch/dpdk_iface.h $DPDK_IFACE
	# TODO: avoid replacing files. Apply an actual patch
	# sed -i 's/.ndo_tx_timeout         = netdev_no_ret,/.ndo_tx_timeout         = netdev_no_ret_dum,/g' $DPDK_IFACE
	# NEW_FUNC="static void netdev_no_ret_dum(struct net_device *netdev, unsigned int txqueue) { (void)netdev; return; }"
	# if [[ "$(grep --line-regexp "$NEW_FUNC" "$DPDK_IFACE")" ]];then
	# 	echo "$DPDK_IFACE is already in the desired state"
	# else
	# 	echo "$NEW_FUNC" >> $DPDK_IFACE
	# 	echo "MODIFIED $DPDK_IFACE"
	# fi
fi

echo -e "\n"
echo "Editing $RTE_SDK/mk/rte.app.mk"
if grep "ldflags.txt" $RTE_SDK/mk/rte.app.mk > /dev/null
then
    :
else
    sed -i -e 's/O_TO_EXE_STR =/\$(shell if [ \! -d \${RTE_SDK}\/\${RTE_TARGET}\/lib ]\; then mkdir \${RTE_SDK}\/\${RTE_TARGET}\/lib\; fi)\nLINKER_FLAGS = \$(call linkerprefix,\$(LDLIBS))\n\$(shell echo \${LINKER_FLAGS} \> \${RTE_SDK}\/\${RTE_TARGET}\/lib\/ldflags\.txt)\nO_TO_EXE_STR =/g' $RTE_SDK/mk/rte.app.mk
fi
echo "Modified $RTE_SDK/mk/rte.app.mk"

echo -e "\n"
echo "#####################"
echo "Successfully applied the path"
echo "You can now run ./install-dpdk.sh and then ./install-mtcp.sh"
echo "#####################"
