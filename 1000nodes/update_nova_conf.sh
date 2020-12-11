#!/bin/bash
for i in `seq 1 67`;do hostname=c${i}.$(hostname | awk -F '.' '{print $1}');docker cp nova.conf ${hostname}:/etc/nova/nova.conf;docker exec -i ${hostname} systemctl restart openstack-nova-compute & done
