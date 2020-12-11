#!/bin/bash -x
#ssh ecm0001 "docker stop v1.ecm0001;docker start v1.ecm0001;docker stop v2.ecm0001;;docker start  v2.ecm0001;"
#for i in `seq 2 9`;do ssh ECM00$i "docker stop v1.ECM00$i;docker start v1.ECM00$i;docker stop v2.ECM00$i;docker start v2.ECM00$i;";done
#for i in `seq 10 15`;do ssh ECM0$i "docker stop v1.ECM0$i;docker start v1.ECM0$i;docker stop v2.ECM0$i;docker start v2.ECM0$i;";done
for i in `seq 51 60`;do ssh 172.31.2.${i} "hostname=\$(hostname -s);for v in \$(seq 1 8);do docker restart v\${v}.\${hostname};done";done
