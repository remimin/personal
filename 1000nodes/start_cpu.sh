#!/bin/bash -x
for i in `seq 1 67`;do hostname=c${i}.$(hostname | awk -F '.' '{print $1}');docker start ${hostname} & done
