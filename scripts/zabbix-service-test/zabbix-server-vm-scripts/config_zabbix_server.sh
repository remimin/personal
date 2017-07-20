#!/bin/bash
dirname=$(dirname $0)

source ${dirname}/functions
DEBUG=${DEBUG:-0}
if [ $DEBUG -ne 0 ];then
  set -x
fi

set -e
programname=$0
# zabbix server config file
# owner zabbix
zabbix_conf='/etc/zabbix/zabbix_server.conf'
# zabbix frontend config file
# owner apache
zabbix_web_conf='/etc/zabbix/web/zabbix.conf.php'
zabbix_httpd_conf='/etc/httpd/conf.d/zabbix.conf'
log_file=${dirname}/zabbix_init.log
zabbix_api="http://127.0.0.1:80/zabbix/api_jsonrpc.php"

usage(){
  echo "Usage: ${programname##*/} <DBHost> -P <DBPassword> [-d <DBName>] [-u <DBUser>]"
  echo "                          [-p <DBPort>][-l <ListenIP>:<ListenPort>]"
  echo -e "\n"
  echo "DBHost: Zabbix Server database host ip address."
  echo "DBName: Zabbix Server database name"
  echo "DBUser: Database user name"
  echo "DBPassword: Database password"
  echo "DBPort: Database port. Default:3306"
  echo "ListenIP: Zabbix Server listen ip. Default:0.0.0.0"
  echo "ListenPort: Zabbix Server listen port. Default:10051"
}

if [ $# -lt 3 ];then
  usage
  exit 0
fi

while [ $# -gt 0 ];do
 case $1 in
   '-d')shift 1;DBName=$1;shift 1;;
   '-u')shift 1;DBUser=$1;shift 1;;
   '-P')shift 1;DBPassword=$1;shift 1;;
   '-p')shift 1;DBPort=$1;shift 1;;
   '-l')shift 1;Listen=$1;shift 1;;
   *)DBHost=$1;shift 1;;
 esac 
done

if [ -z ${DBHost} ];then
  log_print "ERROR: Database host is needed."
  usage
  exit 1
fi

if [ -z ${DBPassword} ];then
  log_print "ERROR: Databse password is needed."
  usage
  exit 1
fi

# Check DBHost ip address validation
check_ipaddr ${DBHost}

# Get zabbix server Listen ip and listen port
if [ ! -z ${Listen} ];then
  analyze_ip_port ${Listen}
fi

## Get database information for zabbix server
DBName=${DBName:-'zabbix'}
DBUser=${DBUser:-'zabbix'}
DBPort=${DBPort:-'3306'}
ListenPort=${ListenPort:-'10051'}
ListenIP=${ListenIP:-'0.0.0.0'}


log_print "Checking Database Connection....."
check_mysql_conn

# Change zabbix server config
# backup origianl zabbix config
postfix=`date +%Y%m%d%H%M%S`
if [ ! -f ${zabbix_conf}.orig ];then
  cp ${zabbix_conf} ${zabbix_conf}.orig
else
  cp ${zabbix_conf} ${zabbix_conf}.${postfix}
fi

tmp_conf=${zabbix_conf}.tmp
cat ${zabbix_conf} |grep -v -E "^#|^$" >${tmp_conf}

conf_keys='DBHost DBName DBPort DBUser DBPassword ListenIP ListenPort'
for key in ${conf_keys};do
 override_value ${tmp_conf} ${key} 
done
cp -f ${tmp_conf} ${zabbix_conf}
chown zabbix:zabbix ${zabbix_conf}

## Generate zabbix server frontend config

if [ -f ${zabbix_web_conf} ];then
  mv ${zabbix_web_conf} ${zabbix_web_conf}.${postfix}
fi
cp ${dirname}/zabbix.conf.php.template ${zabbix_web_conf}
sed -i "s/DBHost/${DBHost}/g;s/DBName/${DBName}/g;s/DBPort/${DBPort}/g;s/DBUser/${DBUser}/g;s/ListenPort/${ListenPort}/g;s/DBPassword/${DBPassword}/g" ${zabbix_web_conf}
if [ "${ListenIP}" != '0.0.0.0' ];then
  sed -i "s/ListenIP/${ListenIP}/g" ${zabbix_web_conf}
else
  sed -i "s/ListenIP/localhost/g" ${zabbix_web_conf}
fi

## Change httpd config file

sed -i "s/# php_value date.timezone.*/php_value date.timezone Asia\/Shanghai/g" ${zabbix_httpd_conf}

## Load Zabbix Database Schema and Data
log_print "Initialize zabbix database ......" 
zcat /usr/share/doc/zabbix-server-mysql-3.2.6/create.sql.gz | mysql --defaults-file=/tmp/my.cnf zabbix
cat ${dirname}/import_init_config.sql | mysql --defaults-file=/tmp/my.cnf zabbix
mysql --defaults-file=/tmp/my.cnf zabbix -e "update zabbix.users set lang='zh_CN' where alias='Admin'"
log_print "Done"
log_print "Start zabbix server"
systemctl start zabbix-server
log_print "Start Http service"
systemctl start httpd
systemctl status zabbix-server
systemctl status httpd
update_admin_passwd
rm -f /tmp/my.cnf
