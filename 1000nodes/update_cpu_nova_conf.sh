#!/bin/bash
for i in `seq 51 65`;do scp nova.conf 172.31.2.${i}:~/;done
ansible all -i /root/hosts -m shell -a  "/root/update_nova_conf.sh"
