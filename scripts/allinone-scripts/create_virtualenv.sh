#!/bin/bash
programname=$0
usage(){
  echo "usage: ${programname##*/} <workon home dir>"
}

if [ $# -ne 1 ];then
  usage
  exit 0
fi

WORKON_HOME=${1}
if [ -f ${WORKON_HOME} ];then
  mkdir ${WORKON_HOME}
fi
venv_path=`which virtualenvwrapper.sh`
cat >>~/.bashrc <<EON
if [ -f  ${venv_path} ];then
  export WORKON_HOME=${WORKON_HOME}
  source ${venv_path} 
fi
EON
