#!/bin/bash -x

get_cpu_log(){
  return $array
}


vm=$1
if [ -z $vm ];then
  echo "Usage: ./get_vm_log.sh instancename"
  exit 1
fi
if [ -f ${vm}.log ];then
 >${vm}.log
fi
req=$(grep "$vm" /var/log/nova/nova-api.log | awk '{print $6}'|tr -d '[')
#postfix=41
for postfix in `seq 42 43`;do
  if [ -z $req ];then
    req=$(ssh 172.31.2.${postfix} "grep \"${vm}\" /var/log/nova/nova-api.log | awk '{print \$6}'|tr -d '['")
  fi
done
grep ${req} /var/log/nova/*.log | tee -a ${vm}.log
for i in `seq 42 46`;do ssh 172.31.2.${i} "grep ${req} /var/log/nova/*.log ";done | tee -a ${vm}.log

result=($(cat ${vm}.log | grep "Selected host" |grep nova-conductor.log | awk -F ":|;|]" '{print $6,$8}'))
host=${result[1]}
uuid=${result[0]}

if [ -z ${host} ];then
  echo "Cannot found vm host."
  exit 1
fi
echo "------\nVM on ${host}"
IFS='.' read -r -a array <<< "$host"
cpu=${array[1]}
ssh $cpu "docker exec -i ${host} grep ${uuid} /var/log/nova/nova-compute.log" | tee -a ${vm}.log
