cd /
EDGEHOSTNAME=`printf  DE00; echo $RANDOM | md5sum | head -c 6; echo ;`
echo $EDGEHOSTNAME
sed -i '/127\.0\.1\.1/d;' etc/hosts
echo $EDGEHOSTNAME > etc/hostname
echo "127.0.0.1 $EDGEHOSTNAME" >> etc/hosts
sed -i s/spare001/$EDGEHOSTNAME/  etc/teleport.yaml
systemctl enable teleport
systemctl restart teleport
systemctl enable ssh
systemctl restart ssh
rm -rf root/raspi-edge-pub
git clone https://github.com/bejoynr/raspi-edge-pub
if [ -a root/raspi-edge-pub/twoboot.sh ];
then
    cp root/raspi-edge-pub/twoboot.sh usr/bin/twoboot.sh
    chmod u+x usr/bin/twoboot.sh
else
    echo "File does not exist."
fi
sed -i 's/oneboot/twoboot/' var/spool/cron/crontabs/root
touch /tmp/oneboot
