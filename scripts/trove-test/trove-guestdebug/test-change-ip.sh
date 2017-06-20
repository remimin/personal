#!/bin/bash -x

token=32862197d2dd42d8bb46bb5209621c30
tenant_id=dbdd1e7b27884c39ae19194b587a83c5
get_instances(){
msg=0
while [[ ${msg} -eq 0 ]];do
    echo ${message}
    msg=$(rabbitmqadmin get queue=change-ip requeue=false |grep trove.instance.change_fixed_ip |wc -l)
    sleep 0.1
done
curl -i -X GET http://127.0.0.1:8779/v1.0/${tenant_id}/instances -H "User-Agent: trove keystoneauth1/2.18.0 python-requests/2.14.2 CPython/2.7.5" -H "Accept: application/json" -H "X-Auth-Token: ${token}";
}

get_instances
