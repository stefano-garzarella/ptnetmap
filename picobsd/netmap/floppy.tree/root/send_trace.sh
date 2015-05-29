#!/bin/sh

IP_HOST="10.0.0.200"
PORT_HOST="33333"

if [ x"$1" != x ]
 then
	IP_HOST=$1
fi

if [ x"$2" != x ]
 then
	PORT_HOST=$2
fi

sysctl net.inet.tcp.gso=0
sysctl net.inet.tcp.gso_tstmp=0
sysctl -b kern.ts.data | nc  $IP_HOST $PORT_HOST
sysctl net.inet.tcp.gso_tstmp=1
#echo $IP_HOST $PORT_HOST
