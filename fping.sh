LOCALIP=$(ip -4 -h -o address show wlan0 | awk -F / '{print $1}' | awk '{print $4}')
echo $LOCALIP
THIRDOCTET=$(ip -4 -h -o address show wlan0 | awk -F / '{print $1}' | awk '{print $4}'| awk -F. '{print $3}')
echo "start addr 192.168.$THIRDOCTET.1"
echo "last addr 192.168.$THIRDOCTET.254"
echo "Cameras.info file##########"
cat /etc/health/cameras.info
echo "###############"
echo "Hosts Alive"
fping -s -g 192.168.$THIRDOCTET.1 192.168.$THIRDOCTET.254 -n -a -q -A
echo "ARP list"
sleep 10
arp -a
