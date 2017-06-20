#!/bin/bash -x
source /root/openrc
token=`openstack token issue |grep "\bid\b"|awk '{print $4}'`
curl -X POST http://localhost:8042/v2/alarms -H "Content-Type: application/json" -H "Accept: application/json" -H "X-Auth-Token:${token}" -d @./composite_alarm
