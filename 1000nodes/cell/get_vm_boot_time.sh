#!/bin/bash -x
mysql nova_cell1 -N -e "select display_name,timestampdiff(SECOND,created_at,launched_at) from instances where display_name like \"$1_%\"" | tee ${1}_boot_vm.log
