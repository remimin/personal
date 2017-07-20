#!/bin/bash
source $(dirname $0)/common_functions
phrase=${phrase:-'start'}
DEBUG=${DEBUG:-0}
KEYPATH=$(dirname $0)/keys

trovekeyname='trove_id_rsa'

programname=$0

usage(){
  echo "usage: ${programname##*/} <zabbix_server_name> <image> <network> <keyname>"
  echo "                           [-f <flavor> ] [-df <database_flavor>]"
  echo "                           [-ds <datastore_name>] [-dv <datastore_version]"
  echo "                           [-u <zabbix_user_name>] [-p <zabbix_password>]
                                   [-d <zabbix_database_name>]"
  echo "image: Zabbix Server image name or uuid"
  echo "network: Tenant network name or uuid"
  echo "keyname: zabbix server ssh key name"
  echo "flavor: zabbix server flavor. Default: m1.small"
  echo "database_flavor: zabbix database flavor. Default: m1.small"
  echo "datastore_name: Database datastore name: Default ubuntu-percona"
  echo "datasotre_version: Datastore version. Default:5.6.33-4"
  
} 

if [ $# -lt 1 ] || [ $1 == "?" ] || [ $1 == 'help' ] || [ $1 == '--help' ];then
  usage
  exit 0
fi

while [ $# -gt 0 ];do
  case $1 in
     '-u') shift 1; zabbix_user=$1;shift 1;;
     '-p') shift 1; zabbix_passwd=$1;shift 1;;
     '-d') shift 1; zabbix_db=$1;shift 1;;
     '-df') shift 1; TROVE_FLAVOR=$1;shift 1;;
     '-f') shift 1; FLAVOR=$1;shift 1;;
     '-ds') shift 1; DATASTORE=$1;shift 1;;
     '-dv') shift 1; DATASTORE_VERSION=$1;shift 1;;
     *) if [ -z $zabbix_server ];then
          zabbix_server=$1;
        elif [ -z $image ];then
          image=$1
          if [ $(glance image-list |grep $image | wc -l) -eq 0 ];then
            echo "ERROR Image doesn't exist"
            usage
            exit 1
          fi
        elif [ -z $network ];then
          network=$1;
          NETID=$(neutron net-list |grep ${network} | awk '{print $2}')
          if [ -z $NETID ];then
            echo "ERROR Network $network."
            usage;exit 1;
          fi
        elif [ -z $keyname ];then
          keyname=$1;
          if [ $(nova keypair-list |grep $keyname |wc -l) -eq 0 ];then
            echo "ERROR keypair name: $keyname"
          fi
        fi
        shift 1
  esac
done
if [ -z $zabbix_server ] || [ -z $NETID ] || [ -z $keyname ];then
  usage
  exit 1
fi

TROVENAME="${zabbix_server}_db"
DATASTORE=${DATASTORE:-'ubuntu-percona'}
DATASTORE_VERSION=${DATASTORE_VERSION:-'5.6.33-4'}
FLAVOR=${FLAVOR:-'m1.small'}
TROVE_FLAVOR=${TROVE_FLAVOR:-'m1.small'}
zabbix_user=${zabbix_user:-'zabbix'}
zabbix_db=${zabbix_db:-'zabbix'}
zabbix_passwd=${zabbix_passwd:-'Zabbix1234'}


echo "Create trove percona instance"
echo "datastore: $DATASTORE"
echo "datastore version: $DATASTORE_VERSION"
echo "trove internal network: $NETWORK"
echo "Instance name: $TROVENAME"
echo "Trove Flavor: $TROVE_FLAVOR"
if [ $phrase == 'start' ];then
  create_trove_instance
  phrase="boot_server"
fi

# Boot Zabbix Server image
if [ $phrase == 'boot_server' ];then
  nova_id=$(nova boot --image ${image} --flavor ${FLAVOR} --key-name ${keyname} --nic net-id=${NETID} ${zabbix_server} |grep " id "| awk '{print $4}')
  if [ -z $nova_id ];then
    echo "ERROR boot zabbix server"
    exit 1
  fi
  echo "Waiting Zabbix Server Active"
  timeout=180
  while [ $timeout -gt 0 ];do
    status=`nova show $nova_id |grep status|awk '{print $4}'`
    if [ $status == "ACTIVE" ];then
       echo "Zabbix Server starting"
       break
    elif [ $status == "ERROR" ];then
      echo "Zabbix Server boot failed"
      nova show $nova_id
      exit 1
    fi
    sleep 10
    timeout=$(( timeout-1 ))
  done
  phrase='create_db_user'
fi

opts=''
if [ ! -z $zabbix_user ];then
opts+=" -u $zabbix_user"
fi
if [ ! -z $zabbix_db ];then
opts+=" -d $zabbix_db"
fi
if [ ! -z $zabbix_passwd ];then
  opts+=" -p $zabbix_passwd"
fi

if [ $phrase == 'create_db_user' ];then
  ## Create Zabbix Database user and database
  
  $(dirname $0)/create_zabbix_user.sh ${TROVENAME} $opts
  phrase='open_port'
fi
trove_nova_id=`nova list |grep " ${TROVENAME} "| awk '{print $2}'`

if [ $phrase == 'open_port' ];then
  ## Check SSH security group rule
  sg_id=$(get_security_groups $nova_id)
  
  ## Add Zabbix server and ssh port 
  ## Add 
  add_port_accessable 10051 $sg_id
  add_port_accessable 22 $sg_id
  
  ## Add db instance ssh port and zabbix agent port
  trove_sg_id=$(get_security_groups ${trove_nova_id})
  add_port_accessable 22 $trove_sg_id
  add_port_accessable 10050 $trove_sg_id
  phrase='config_zabbix_server'
fi

zabbix_server_fixed_ip=$(get_fixed_ip $nova_id $NETID)
trove_fixed_ip=$(get_fixed_ip $trove_nova_id $NETID)
# Init Zabbix server
if [ $phrase == 'config_zabbix_server' ];then
  zabbix_opts=$trove_fixed_ip
  if [ ! -z $zabbix_user ];then
  zabbix_opts+=" -u $zabbix_user"
  fi
  if [ ! -z $zabbix_db ];then
  zabbix_opts+=" -d $zabbix_db"
  fi
  if [ ! -z $zabbix_passwd ];then
    zabbix_opts+=" -P $zabbix_passwd"
  fi

  config_zabbix_server $NETID $zabbix_server_fixed_ip "${KEYPATH}/$keyname" $zabbix_opts
  phrase='config_zabbix_agent'
fi
if [ $phrase == 'config_zabbix_agent' ];then
  config_zabbix_agent $NETID $trove_fixed_ip "${KEYPATH}/$trovekeyname" $zabbix_server_fixed_ip
  phrase='done'
fi
