#!/bin/bash

RUN_DIR="${HOME}/repos/ptnetmap-github/run"
SSH_CMD="sshpass -p p ssh root@localhost -p 20001"

cd $RUN_DIR

#taskset -c 0,1 ./start-e1000-passthrough $@ &
./start-e1000-passthrough -noout $@ &

sleep 6

$SSH_CMD modprobe netmap
$SSH_CMD modprobe e1000 paravirtual=1
sleep 3
$SSH_CMD ifconfig eth1 up
$SSH_CMD ifconfig eth2 up

#$SSH_CMD ./start_ste

sleep 4
