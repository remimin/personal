#!/bin/bash -x
set -e
image=$1
if [ -z $image ];then
  exit 1
fi
rbdk='rbd --user glance -k /etc/ceph/ceph.client.glance.keyring -p images'
${rbdk} import ${image}
${rbdk} snap create ${image}@snap
${rbdk} snap protect ${image}@snap
source /root/openrc
id=$(openstack image create --container-format bare --disk-format raw --property hw_qemu_guest_agent=yes ${image} -f value -c id)
#glance location-add --url rbd://34843874-6e68-427a-b45e-3d73fe319a08/images/${image}/snap  --metadata '{"backend": "ceph_rocky"}' ${id}
glance location-add --url rbd://34843874-6e68-427a-b45e-3d73fe319a08/images/${image}/snap  ${id}
