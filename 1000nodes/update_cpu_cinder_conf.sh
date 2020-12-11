#!/bin/bash
for i in `seq 51 60`;do scp cinder.conf 172.31.2.${i}:~/;done
ansible az01 -i /root/hosts -m shell -a  "/root/update_cinder_conf.sh"
