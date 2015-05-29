#!/bin/sh

#	usage change_mtu.sh new_MTU_value

ip_old=$(ifconfig em0 | grep inet)
mtu_old=$(ifconfig em0 | grep mtu | cut -f 6 -d ' ')

ifconfig em0 mtu $1
ifconfig em0 delete
ifconfig em0 $ip_old

mtu_new=$(ifconfig em0 | grep mtu | cut -f 6 -d ' ')

echo "em0 mtu: $mtu_old -> $mtu_new"

