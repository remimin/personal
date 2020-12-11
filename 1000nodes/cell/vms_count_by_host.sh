#!/bin/bash -x
mysql nova_cell1 -e "select count(id), host from instances where display_name like \"${1}%\" group by host"
