#!/bin/bash -x
server_id=${1}
mysql -D trove -e "select id from instances where compute_instance_id like \"${server_id}\""
