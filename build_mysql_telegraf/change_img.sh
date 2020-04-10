#!/bin/bash -x
tmp_root="/tmp/m57"
if [ ! -d $tmp_root ];then
mkdir -p ${tmp_root}
fi
umount ${tmp_root}
guestmount -a $1 -m /dev/centos/root ${tmp_root}
mount --bind /dev ${tmp_root}/dev
mount -t sysfs none ${tmp_root}/sys
mount -t proc none ${tmp_root}/proc/
