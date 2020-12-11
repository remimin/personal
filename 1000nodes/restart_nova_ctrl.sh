#!/bin/bash
for i in `seq 41 43`;do ssh  172.31.2.${i} "systemctl restart openstack-nova-api openstack-nova-scheduler openstack-nova-conductor placement-api|grep Active";done
for i in `seq 44 46`;do ssh  172.31.2.${i} "systemctl restart openstack-nova-scheduler openstack-nova-conductor";done
for i in `seq 41 43`;do ssh  172.31.2.${i} "systemctl status openstack-nova-api openstack-nova-scheduler openstack-nova-conductor placement-api|grep Active";done
for i in `seq 44 46`;do ssh  172.31.2.${i} "systemctl status openstack-nova-scheduler openstack-nova-conductor|grep Active";done
