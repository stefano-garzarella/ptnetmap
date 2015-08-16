#!/bin/bash

DIR_REPOS="${HOME}/repos"
#DIR_REPOS=".."

git submodule init

#if you want to use the references to already cloned repos, set DIR_REPOS
if [ x"$DIR_REPOS" != x ]; then
    git submodule update --reference ${DIR_REPOS}/netmap -- netmap
    git submodule update --reference ${DIR_REPOS}/linux -- linux
    git submodule update --reference ${DIR_REPOS}/qemu -- qemu
    git submodule update --reference ${DIR_REPOS}/freebsd -- freebsd
    git submodule update --reference ${DIR_REPOS}/bhyve -- bhyve
else
    git submodule update --init —recursive
fi
