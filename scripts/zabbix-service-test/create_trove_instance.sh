#!/bin/bash
create_trove_instance(){
trove create "$TROVENAME"  $TROVEFLAVOR --datastore ${DATASTORE} --datastore_version ${DATASTORE_VERSION} --nic net-id=${NETID} --size 1
# Timeout 10 minutes
timeout=60
echo "Wait Trove instance Active ..."
while 1;do
    status=`trove list |grep  $TROVENAME | awk '{print $10}'`
    if [ -z $status ];then
      return 1
    fi 
    if [ "$status" == "ACTIVE" ];then
         trove show $TROVENAME
         return 0
    fi
    sleep 10
    timeout=(( $timeout - 1 ))
done
return 1
}
