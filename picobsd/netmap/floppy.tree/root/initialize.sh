#!/bin/sh

#set -x

usage() 
{
	echo -e "\nUSAGE: initialize [options]"
	echo -e "\nOptions:"
	echo -e "  -h\t\t\tHelp"
	echo -e "  -csb\t\tEnable(def)/Disable CSB (dev.em.0.csb_on=[0,1])"
	echo -e "  -itr\t\tvalue\tSet the interrupt delay limit [usec]"
	echo -e "  -dack\t\tEnable(def)/Disable delayed ack (net.inet.tcp.delayed_ack=1)"
	echo -e "  -mtu\t\tvalue\tSet the mtu value"
	echo -e "  -msb\t\tvalue\tSet the maxsockbuf value (kern.ipc.maxsockbuf)"
	echo -e "  -maxfrags\t\tvalue\tSet the maxfragsperpacket value (net.inet.ip.maxfragsperpacket)"
}


CSB=1
ITR=488
DACK=1

MTU=1500
MAXSOCKBUF=14
MAXFRAGS=1000

while [ x"$1" != x ] ; do
	case "$1" in
	-maxfrags)
		MAXFRAGS=$2
		shift
		;;
	-csb)
		CSB=$2
		shift
		;;
	-itr)
		ITR=$2
		shift
		;;
	-dack)
		DACK=$2
		shift
		;;
	-mtu)
		MTU=$2
		shift
		;;
	-msb)
		MAXSOCKBUF=$2	#MB
		shift
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


sysctl dev.em.0.csb_on=$CSB			#Enable paravirt

sysctl dev.em.0.rx_abs_int_delay=0		#Disable old mitigation
sysctl dev.em.0.tx_abs_int_delay=0
sysctl dev.em.0.rx_int_delay=0
sysctl dev.em.0.tx_int_delay=0

sysctl dev.em.0.itr=$ITR			#Disable mitigation

sysctl net.inet.tcp.rfc1323=1			#Enable RFC 1323 (High speed)
sysctl net.inet.tcp.delayed_ack=$DACK		#Disable Delayed Ack

sysctl kern.ipc.maxsockbuf=$(( $MAXSOCKBUF*(1<<20) ))

sysctl net.inet.ip.maxfragsperpacket=$MAXFRAGS	#Default limit is 14
						#Big UDP packets don't arrive

./change_mtu.sh	$MTU				#Set mtu

ifconfig em0 inet add 10.0.0.1/24
ifconfig em0 inet6 add 10::1/64
