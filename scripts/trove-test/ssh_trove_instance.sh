#!/bin/bash -x
instance=$1
enable_sg=${2:-0}
key=${3:-'/root/trove_id_rsa'}
_id=($(trove show ${instance} |grep -E "server_id|\bid\b" | awk '{print $4}'))
server_id=${_id[1]}
instance=${_id[0]}
if [[ ${enable_sg} -ne 0 ]];then
neutron security-group-rule-create  --protocol tcp --port-range-min 22 --port-range-max 22 --direction ingress --remote-ip-prefix 0.0.0.0/0 HHY-TROVE-SecGroup_${instance}
fi
net_ips=($(nova show ${server_id} |grep "network" | awk '{print $2, $5}'))
net_id=$(neutron net-list |grep ${net_ips[0]}|awk '{print $2}')
ip netns exec qdhcp-${net_id} ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i $key ubuntu@${net_ips[1]}
