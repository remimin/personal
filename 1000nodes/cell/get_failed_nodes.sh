#!/bin/bash
mysql nova_cell1 -e "select stats from compute_nodes where stats != '{\"failed_builds\": \"0\"}'" |wc -l
