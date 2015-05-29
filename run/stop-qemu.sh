#!/bin/bash

#  usage: 	./stop-qemu.sh ID_VM_1 ID_VM_2 ...
#
#  eg. 		./stop-qemu.sh 1 2
#

ID="1"

if [ x"$1" != x ] ; then
	ID=$1
	shift
fi

echo "quit" | nc localhost 1000$ID
sleep 1

while [ x"$1" != x ] ; do
	echo "quit" | nc localhost 1000$1
	sleep 1
	shift
done

sudo killall qemu-system-x86_64
