#!/bin/bash
echo $(date "+%H:%M@%d-%m-%Y ")  $(curl -s  https://google.com  2>&1 > /dev/null  && echo  succeeded || echo failed) $(iwconfig wlan0 | grep Signal) | tee -a /var/tmp/connectivity.log
