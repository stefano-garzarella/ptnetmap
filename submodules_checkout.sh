#!/bin/bash

BRANCH="ptnetmap_memdev"
SUB_GIT="netmap
linux
qemu
freebsd"

set -x
for d in $SUB_GIT
do
    cd "$d"
    git fetch
    git checkout -b $BRANCH origin/$BRANCH
    cd -
done
