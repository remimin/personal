#!/bin/bash
CMD=$@
hostname=$(hostname | awk -F '.' '{print $1}')
for i in `seq 1 67`;do docker exec -i c${i}.${hostname} $CMD & done
