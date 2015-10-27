ptnetmap: a netmap passthrough for virtual machines
===========

--- ALPHA version of ptnetmap ---

ptnetmap allows userspace applications running in a guest VM to safely use any
netmap port opened in the host with near-native performance (physical devices [14.88 Mpps],
software switches [20 Mpps], shared memory channels [75 Mpps]).

Compared to existing solutions, this kind of passthrough has most of netmap strengths:
 * vendor independence
 * use of commodity hardware
 * the possibility to avoid busy polling.

Moreover, it offers a degree of flexibility on the amount of memory sharing among virtual machines: VALE ports can be used to isolate untrusted VMs from each other, while netmap pipes can be used to create chains of trusted VMs accessing the same buffer memory.

Our preliminary version supports linux/KVM as a host and Linux or FreeBSD as a guest.
Now we are developing host ptnetmap support for FreeBSD/bhyve.

##Repository structure
This repository has a submodules for each part that we have modified to implement ptnetmap:
 * netmap
 * qemu
 * linux
 * bhyve
 * freebsd

In each submodules, we have "ptnetmap" branch that contains our modifications. In bhyve and freebsd and bhyve, we also have "ptnetmap10" branch that are based on FreeBSD 10-STABLE.
In linux/freebsd submodules we only modified the e1000 and virtio-net device drivers to support ptnetmap.

Notes:
Since linux and freebsd repos are very large, if you have already checked out these repos (also from github.com), it is better if you use the <code>init_submodules.sh</code> script to initialize them with a reference to the repos already downloaded. (setting DIR_REPOS).
Otherwise you can do <code>git submodule update --init —recursive</code> in ptnetmap dir to initialize and download all submodules.
After that, you can use the <code>submodules_checkout.sh</code> script to switch to the "ptnetmap" branch in each submodules.

##Links
[GSoC2015 - A FreeBSD/bhyve version of the netmap virtual passthrough for VMs.] (https://wiki.freebsd.org/SummerOfCode2015/ptnetmapOnBhyve#preview)

[ptnetmap slides - AsiaBSDCon 2015] (https://socsvn.freebsd.org/socsvn/soc2015/stefano/ptnetmap-docs/ptnetmap_AsiaBSDCon_2015.pdf)

[Virtual device passthrough for high speed VM networking] (http://info.iet.unipi.it/~luigi/papers/20150315-netmap-passthrough.pdf) Stefano Garzarella, Giuseppe Lettieri, Luigi Rizzo

##Configure and compile ptnetmap modules
NETMAP host (netmap/LINUX):
```
$ ./configure --kernel-dir=../kernel-host/ --enable-ptnetmap-host
$ make -j
```

NETMAP guest (netmap/LINUX):
```
$ ./configure --kernel-dir=../linux/ --enable-ptnetmap-guest --drivers=virtio-net
$ make -j
```

QEMU:
```
$ ./configure --target-list=x86_64-softmmu  --enable-e1000-paravirt --enable-netmap --enable-ptnetmap --extra-cflags=-I$HOME/repos/ptnetmap/netmap/sys --python=python2
$ make -j
```

##Run ptnetmap
```
[host] sudo insmod netmap.ko
[host] sudo where/is/qemu-system-x86_64 .... -device virtio-net-pci,netdev=mynet -netdev netmap,ifname=vale0:1,passthrough=on,id=mynet ..

[guest] modprobe netmap
[guest] modprobe vitio-net
[guest] ifconfig eth0 up
```

