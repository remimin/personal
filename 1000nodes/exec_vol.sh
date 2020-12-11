#!/bin/bash
CMD=$@
hostname=$(hostname | awk -F '.' '{print $1}')
for i in `seq 1 8`;do docker exec -i v${i}.${hostname} $CMD;done
