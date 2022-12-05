#!/bin/bash
#* */4 * * * ~/diskusage.sh | tee -a /var/tmp/diskusage.log
ALERT=90 # alert level
df -H /| grep -vE '^Filesystem' | awk '{ print $5 " " $1 }' | while read -r output;
do
  echo "$output"
  usep=$(echo "$output" | awk '{ print $1}' | cut -d'%' -f1 )
  partition=$(echo "$output" | awk '{ print $2 }' )
  if [ $usep -ge $ALERT ]; then
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" > /var/tmp/df-message.txt
rm -rf /var/cache/apt
sudo apt-get clean
sudo apt-get autoremove
dpkg-query -W -f='${Installed-Size;8}  ${Package}\n' | sort -n | tail -10 > /var/tmp/large-packages.list
  fi
done
