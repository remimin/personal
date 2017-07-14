#!/bin/bash
net=${1:-'trove-net3'}
datastore=${2:-'ubuntu-percona'}
datastore_version=${3:-'5.6.33-2'}
name_prefix=${4:-'minmin'}
lastest_name=$(trove list |grep 'minmin-'|awk '{print $4}' |sort -r | head -1)
name=$(( ${laste_name:7} + 1 ))
net_id=$(neutron net-list |grep ${net} | awk '{print $2}')
trove create "${name_prefix}-${name}" m1.small --datastore ${datastore} --datastore_version ${datastore_version} --nic net-id=${net_id} --size 1
