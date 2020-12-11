#!/bin/bash
CMD=$@
#ssh ecm0001 "docker cp ~/dispatcher.py v1.ecm0001:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py;docker cp ~/dispatcher.py v2.ecm0001:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py;"
#for i in `seq 2 9`;do ssh ECM00$i "docker cp ~/dispatcher.py v1.ECM00${i}:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py; docker cp ~/dispatcher.py v2.ECM00${i}:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py;";done
#for i in `seq 10 15`;do ssh ECM0$i "docker cp ~/dispatcher.py v1.ECM00${i}:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py; docker cp ~/dispatcher.py v2.ECM0${i}:/usr/lib/python2.7/site-packages/oslo_messaging/rpc/dispatcher.py;";done
#for i in `seq 51 60`;do
#  ssh 172.31.2.${i} "hostname=\$(hostname -s)
#  for v in `seq 1 8`; do
#    docker cp ~/cinder/manager.py v${v}.\${hostname}:/usr/lib/python2.7/site-packages/cinder/volume/
#  done"
#done
#for i in `seq 51 60`;do ssh 172.31.2.${i} "hostname=\$(hostname -s); for v in \$(seq 1 8); do docker cp ~/cinder/create_volume.py v\${v}.\${hostname}:/usr/lib/python2.7/site-packages/cinder/volume/flows/manager/;done";done
#for i in `seq 51 60`;do ssh 172.31.2.${i} "hostname=\$(hostname -s); for v in \$(seq 1 8); do docker cp ~/cinder/manager.py v\${v}.\${hostname}:/usr/lib/python2.7/site-packages/cinder/volume/;done";done
for i in `seq 51 60`;do ssh 172.31.2.${i} "hostname=\$(hostname -s); for v in \$(seq 1 8); do docker cp ~/dispatcher.py v\${v}.\${hostname}:/usr/lib/python2.7/site-packages//oslo_messaging/rpc/;done";done
