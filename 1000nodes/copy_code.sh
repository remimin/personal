#!/bin/bash
host=$(hostname | awk -F '.' '{print $1}')
for i in `seq 1 67`;do docker cp /root/nova c${i}.${host}:/usr/lib/python2.7/site-packages/; done
