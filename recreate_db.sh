#!/bin/bash
mysql -e "drop database trove"
mysql -e "create database trove"
mysql -e "GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'localhost' IDENTIFIED BY 'trove'";
mysql -e "GRANT ALL PRIVILEGES ON trove.* TO 'trove'@'%' IDENTIFIED BY 'trove'";

