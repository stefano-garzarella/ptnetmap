#!/bin/bash

export QEMU=${QEMU:-/usr/bin/qemu-system-x86_64}
export KERNEL=${KERNEL:-$HOME/Compile/virtual-kernel}
export INITRD=${INITRD:-tftp/ninitrd}
export BSD=${BSD}
export NO_OUT=${NO_OUT:-0}
#SMP=${SMP:-1}
SMP=1


N=$(echo $0|sed -n 's/^.*\([1-9]\)$/\1/p')
[ -z "$N" ] && N=1

KVM=
#[ "$1" = "-kvm" ] && { KVM="-machine accel=kvm"; shift; }
KVM="-machine accel=kvm"

O=
if [ "$BSD"x == x ]; then
    O="$O -kernel $KERNEL/arch/x86/boot/bzImage"
    O="$O -initrd $INITRD"
    if [ "$NO_OUT" == 0 ]; then
        A=(-append "root=/dev/ram0 noacpi clocksource=kvm-clock console=ttyS0")
    else
        A=(-append "root=/dev/ram0 noacpi clocksource=kvm-clock")
    fi
else
    O="$O -hda $BSD"
fi


if [ "$NO_OUT" == 0 ]; then
    O="$O -nographic -serial mon:stdio"
else
    O="$O -nographic -serial /dev/null"
fi
O="$O -monitor tcp::1000$N,server,nowait,nodelay"
O="$O $KVM"
O="$O -m 2G"
O="$O -smp $SMP"
O="$O -device virtio-net-pci,netdev=ssh"
O="$O -netdev user,id=ssh,hostfwd=tcp::2000$N-:22"
#O="$O -device ivshmem,shm=64M"

function start_qemu ()
{
	set -x
	sudo $QEMU $O "${A[@]}" "$@"
	#sudo $QEMU $O "$@"
}
