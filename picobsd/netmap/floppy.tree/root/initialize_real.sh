#!/bin/sh

#set -x

usage() 
{
	echo -e "\nUSAGE: initialize [options]"
	echo -e "\nOptions:"
	echo -e "  -h\t\t\tHelp"
	echo -e "  -dack\t\tEnable(def)/Disable delayed ack (net.inet.tcp.delayed_ack=1)"
	echo -e "  -msb\t\tvalue\tSet the maxsockbuf value (kern.ipc.maxsockbuf)"
	echo -e "  -maxfrags\t\tvalue\tSet the maxfragsperpacket value (net.inet.ip.maxfragsperpacket)"
}

NIC="ix1"
IP="10.8.8.3/24"
IP6="10::1/64"
TSO="tso"
LRO="-lro"
#TXCSUM="-txcsum"
TXCSUM=""

DACK=1

MAXSOCKBUF=14
MAXFRAGS=1000

while [ x"$1" != x ] ; do
	case "$1" in
	-maxfrags)
		MAXFRAGS=$2
		shift
		;;
	-dack)
		DACK=$2
		shift
		;;
	-msb)
		MAXSOCKBUF=$2	#MB
		shift
		;;
	-nic)
		NIC=$2
		shift
		;;
	-ip)
		IP=$2
		shift
		;;
	-ip6)
		IP6=$2
		shift
		;;
	tso|-tso)
		TSO=$1
		;;
	lro|-lro)
		LRO=$1
		;;
	txcsum|-txcsum)
		TXCSUM=$1
		;;
	-h)
		usage
		exit 0
	;;		
	*)
		echo -e  "\nunknown parameter: $1"
		usage
		exit 1
		break
		;;
	esac
	shift
done


sysctl net.inet.tcp.rfc1323=1			#Enable RFC 1323 (High speed)
sysctl net.inet.tcp.delayed_ack=$DACK		#Disable Delayed Ack
sysctl net.inet.tcp.tso=0

sysctl kern.ipc.maxsockbuf=$(( $MAXSOCKBUF*(1<<20) ))

sysctl net.inet.ip.maxfragsperpacket=$MAXFRAGS	#Default limit is 14
						#Big UDP packets don't arrive

sysctl dev.cpu.0.freq=3000

ifconfig $NIC $TSO $TXCSUM $LRO
ifconfig $NIC inet add $IP 
ifconfig $NIC inet6 add $IP6

dhclient em0
