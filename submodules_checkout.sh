#!/bin/bash

BRANCH="ptnetmap"
SUB_GIT="linux
qemu"

set -x
for d in $SUB_GIT
do
    cd "$d"
    git fetch
    git checkout -b $BRANCH origin/$BRANCH
    cd -
done

BRANCH="ptnetmap10"
SUB_GIT="freebsd
bhyve"

set -x
for d in $SUB_GIT
do
    cd "$d"
    git fetch
    git checkout -b $BRANCH origin/$BRANCH
    cd -
done
