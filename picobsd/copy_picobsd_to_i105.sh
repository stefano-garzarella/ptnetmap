#!/bin/sh

set -x

PICOBSD_DIR="/home/stefano/repos/passthrough/freebsd/release/picobsd/build"
DEST="10.216.1.105"

cd $PICOBSD_DIR

scp build_dir-netmap-amd64/picobsd.bin ${DEST}:/home/stefano/repos/passthrough-full/run/picobsd_ptnetmap.bin
