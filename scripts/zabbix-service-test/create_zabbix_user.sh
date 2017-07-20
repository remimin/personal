#!/bin/bash
programname=$0


usage(){
  echo "usage: ${programname##*/} <instance> [-u <zabbix_user_name>]
                                       [-p <zabbix_password>]
                                       [-d <zabbix_database_name>]"
  echo "      ${programname##*/} help or ${programname##*/} --help
              print usage"
  echo -e "\n\n"
  echo "instance: Trove instance name or id"
  echo -e "-u <zabbix_user_name>\n\t\tzabbix database user name, default:zabbix"
  echo -e "-u <zabbix_password> \n\t\tthe password of zabbix database user, default:Zabbix1234"
  echo -e "-u <zabbix_databse_name>\n\t\tzabbix database name, default:Zabbix"
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
     *) instance=$1; shift 1;
  esac
done

if [ -z $instance ];then
  echo -e "ERROR: Trove instance name or uuid is needed.\n\n"
  usage
  exit 1
fi

echo  "Creating database \"${zabbix_db}\" for user \"$zabbix_user\" with password \"$zabbix_passwd\""

zabbix_user=${zabbix_user:-zabbix}
zabbix_passwd=${zabbix_passwd:-Zabbix1234}
zabbix_db=${zabbix_db:-zabbix}
trove database-create ${instance}  ${zabbix_db}
if [ $? -ne 0 ];then
  exit 1
fi
trove user-create ${instance} ${zabbix_user} ${zabbix_passwd} --databases ${zabbix_db}
