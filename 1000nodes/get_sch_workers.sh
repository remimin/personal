#!/bin/bash
#req_ids=($(cat sch_time.log | awk -F '[' '{print $2}'))
req_ids=
len=${#req_ids[@]}

all_sch() {
  CMD=$@
  for i in `seq 41 46`;do ssh 172.31.2.${i} "echo -n \"----${i}---\";$CMD";done
}

for start in $(seq 0 50 $len); do
   for req in ${req_ids[@]:${start}:50};do all_sch grep $req /var/log/nova/nova-scheduler.log |grep "Selected host" | awk '{print $3}' ;done
done
