#!/bin/bash
for i in `seq 1 8`;do hostname=v${i}.$(hostname | awk -F '.' '{print $1}');docker cp cinder.conf ${hostname}:/etc/cinder/cinder.conf;docker restart ${hostname}; done
