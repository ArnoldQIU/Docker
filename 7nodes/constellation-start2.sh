#!/bin/bash
set -u
set -e

for i in 2
do
    DDIR="qdata/c$i"
    mkdir -p $DDIR
    mkdir -p qdata/logs
    cp "keys/tm$i.pub" "$DDIR/tm.pub"
    cp "keys/tm$i.key" "$DDIR/tm.key"
    rm -f "$DDIR/tm.ipc"
    CMD="constellation-node --url=https://35.184.182.89:80/ --port=80 --workdir=$DDIR --socket=tm.ipc --publickeys=tm.pub --privatekeys=tm.key --othernodes=https://35.184.128.152:80/"
    echo "$CMD >> qdata/logs/constellation$i.log 2>&1 &"
    $CMD >> "qdata/logs/constellation$i.log" 2>&1 &
done

DOWN=true
while $DOWN; do
    sleep 0.1
    DOWN=false
    for i in 2
    do
	if [ ! -S "qdata/c$i/tm.ipc" ]; then
            DOWN=true
	fi
    done
done
