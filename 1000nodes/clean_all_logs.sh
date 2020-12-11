truncate -s 0 /var/log/nova/*.log
truncate -s 0  /var/log/cinder/*.log
truncate -s 0  /var/log/keystone/*.log
for i in `seq 42 46`;do ssh 172.31.2.$i "truncate -s 0 /var/log/nova/*.log;truncate -s 0 /var/log/cinder/*.log; truncate -s 0  /var/log/keystone/*.log" & done
ansible all -i /root/hosts -m shell -a "/root/exec_cpu.sh truncate -s 0 /var/log/nova/nova-compute.log"
ansible all -i /root/hosts -m shell -a "/root/exec_vol.sh truncate -s 0 /var/log/cinder/volume.log"
