#!/usr/local/bin/bash

FREEBSD_TREE=${HOME}/repos/ptnetmap-github/freebsd
NETMAP_TREE=${HOME}/repos/ptnetmap-github/netmap
NETMAP_PICOBSD=${HOME}/repos/ptnetmap-github/picobsd/netmap

#FILE_TO_LINK=
FILE_TO_LINK="sys/dev/netmap
sys/net/netmap.h
sys/net/netmap_user.h"

PATCH_DIR="${HOME}/repos/ptnetmap-github/picobsd/link_netmap_freebsd"

IXGBE_PATCH="${PATCH_DIR}/ixgbe_enable_unsup_sfp.patch"

PICOBSD_PATCH="${PATCH_DIR}/picobsd_fix_iso.patch
${PATCH_DIR}/picobsd_fix_tcp_ext.patch
${PATCH_DIR}/picobsd_fix_loader.patch
${PATCH_DIR}/picobsd_fix_sshd.patch"

#PATCH_TO_APPLY="$IXGBE_PATCH
PATCH_TO_APPLY="$PICOBSD_PATCH"

set -x

while [ true ] ; do
	case $1 in
		--netmap)   # netmap tree
			NETMAP_TREE=$2;
			shift
			;;
		--src)  # FreeBSD tree
			FREEBSD_TREE=$2
			shift
			;;
		--h*)   # help
			echo "sh ... --netmap netmap_tree --src bsd_tree [diff|patch|revert] "
			exit 0
			;;
		revert) # remove additional files
			if [ x"$FILE_TO_LINK" != x ]; then
				(cd $FREEBSD_TREE; git checkout $FILE_TO_LINK; )
			fi
			for file in $PATCH_TO_APPLY
			do
				(cd $FREEBSD_TREE; patch -R -p1 -l < $file; )
			done
			if [ x"$NETMAP_PICOBSD" != x ]; then
				rm $FREEBSD_TREE/release/picobsd/netmap
			fi
			;;
		patch)  # compute diffs
			#(cd $FREEBSD_TREE/sys; \
			#	ln -s $NETMAP_TREE/sys/dev/netmap dev/netmap; \
			#	ln -s $NETMAP_TREE/sys/net/netmap.h net/netmap.h; \
			#	ln -s $NETMAP_TREE/sys/net/netmap_user.h net/netmap_user.h; \
			#	)
			for file in $FILE_TO_LINK
			do
				rm -rf $FREEBSD_TREE/$file
				ln -s $NETMAP_TREE/$file $FREEBSD_TREE/$file
			done

			for file in $PATCH_TO_APPLY
			do
				(cd $FREEBSD_TREE; patch -p1 -l -s < $file; )
			done
			if [ x"$NETMAP_PICOBSD" != x ]; then
				ln -s $NETMAP_PICOBSD $FREEBSD_TREE/release/picobsd/netmap
			fi
			;;
		*)
			break;
	esac
	shift;
done
