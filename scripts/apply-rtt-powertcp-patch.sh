#!/bin/bash
if [[ ${PWD##*/} == "scripts" ]];then
	source config.sh
fi
cp $DIR/src/rtt-powertcp/tcp_in.c $DIR/mtcp/mtcp/src/
cp $DIR/src/rtt-powertcp/tcp_stream.h $DIR/mtcp/mtcp/src/include/

echo -e "\n"
echo "#####################"
echo "Successfully applied Theta PowerTCP implementation"
echo "You can now run ./install-mtcp.sh and then ./setup_vm{1,2}.sh on respective vm"
echo "#####################"
