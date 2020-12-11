#!/bin/bash -x

for i in `seq 42 43`;do ssh 172.31.2.$i "grep \" seconds to select destinations\" /var/log/nova/nova-conductor.log | awk  '{print \$1,\$2, \$13, \$6}'";done | tee -a sch_time.log
grep " seconds to select destinations" /var/log/nova/nova-conductor.log | awk  '{print $1,$2, $13, $6}' | tee -a sch_time.log
cat sch_time.log | awk '{if($3 < 30) a+=1; else if ($3 < 60) b+=1; else if ($3<90) c+=1; else if ($3 < 120) d+=1; else if ($3 < 150) e+=1 } END {print a,b,c,d,e}'
