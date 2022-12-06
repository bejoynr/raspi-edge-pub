#!/bin/bash
touch /var/tmp/setip.log
ping -c1 192.168.1.202
if [ $? == 0 ] ; then
        echo "ip not set to 202" | tee -a /var/tmp/setip.log
else
        sudo ip addr add 192.168.1.202/24 dev wlan0 label wlan0:1
fi
ip addr show| egrep  '(^|\s)wlan0($|\s)|(^|\s)eth0($|\s)|(^|\s)usb0($|\s)' | awk '{print $2" "$(NF)}' | tee -a /var/tmp/setip.log
