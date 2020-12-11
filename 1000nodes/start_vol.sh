#!/bin/bash -x
for i in `seq 5 8`;do hostname=v${i}.$(hostname | awk -F '.' '{print $1}');docker run --privileged=true --hostname ${hostname} --name ${hostname} -itd  172.20.33.101:5000/cinder-volume:latest;done
