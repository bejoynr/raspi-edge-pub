#!/bin/bash
uptime -p | awk -F, '{print $1 "" $2}'|  tr -d '\n'; printf ", IP:"
curl ifconfig.me ; printf ", "
cat /dev/null > /tmp/cams.list
grep -v ^# /etc/health/cameras.info | awk '{print $1}' | while read ip; do curl -o /dev/null -s -w "%{http_code}\n" http://$ip > /dev/null 2>&1 && echo $ip IS UP &>> /tmp/cams.list || echo $ip IS DOWN &>> /tmp/cams.list ; done
printf "Cameras:"
printf `grep UP /tmp/cams.list| wc -l` && printf '/' && printf `wc -l  /tmp/cams.list`
ip -4 -h -o address show wlan0 | awk -F / '{print $1}' | awk '{print $4}' > /tmp/local.ip
printf ", Local IP:"
printf `cat /tmp/local.ip`
printf ", Arch:"
printf `uname -m`
