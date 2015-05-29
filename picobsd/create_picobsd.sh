#!/bin/sh

set -x

PICOBSD_DIR="/home/stefano/repos/passthrough/freebsd/release/picobsd/build"

cd $PICOBSD_DIR

sudo chflags -R noschg build_dir-netmap-amd64/

sudo ./picobsd --src ~/repos/passthrough/freebsd/ --par -v $1 -n netmap
