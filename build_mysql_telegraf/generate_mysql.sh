#!/bin/bash
while true
do
  my_cnf="${HOME}/.my.cnf"
  if [ ! -f ${my_cnf} ];then
    my_cnf=$(su trove -c "echo \${HOME}/.my.cnf")
    if [ ! -f ${my_cnf} ];then
      sleep 5
    else 
      break
    fi
 else
   break
 fi
done

declare $(cat ${my_cnf} | tr -d ' ' | awk -F '=' '{if (NF == 2 ) {print $1 "=" $2}}')
if [ ! -d /etc/telegraf/telegraf.d/ ];then
  mkdir -p /etc/telegraf/telegraf.d/
fi
cat >/etc/telegraf/telegraf.d/mysql.conf <<EON
[[inputs.mysql]]
servers = ["${user}:${password}@tcp(${host})/"]
metric_version = 2
EON

troveguest="/etc/trove/conf.d/guest_info.conf"
declare $(cat $troveguest |egrep "guest_id|datastore")
cat  >/etc/telegraf/telegraf.d/global_tags.conf <<EON
[global_tags]
guest_id = "${guest_id}"
datastore = "${datastore_manager}"
EON
