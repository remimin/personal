#!/bin/bash
if [ -z $1 ];then
  echo "Usage: ./get_job_faults.sh [name]"
  exit 1
fi
name=$1
mysql nova_cell1 -e "select message,display_name,node from instance_faults as faults left join instances on faults.instance_uuid=instances.uuid where instances.display_name like \"${name}%\""
