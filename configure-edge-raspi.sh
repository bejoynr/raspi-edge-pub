echo "clone git repo"
cd /home/nvidia
git clone https://github.com/bejoynr/raspi-edge-pub.git ./raspberrypi
echo "downloading teleport and nomachine"
wget https://get.gravitational.com/teleport-v9.0.4-linux-arm-bin.tar.gz
wget https://download.nomachine.com/download/7.9/Raspberry/nomachine_7.9.2_1_armhf.deb
echo "installing nomachine"
sudo dpkg -i nomachine_7.9.2_1_armhf.deb
sudo apt update
echo "installing packages"
sudo apt install curl shc openssh-server -y
cp -r ../raspberrypi /home/nvidia/
cd /home/nvidia/raspberrypi
echo "Installing teleport"
tar zxf teleport-v9.0.4-linux-arm-bin.tar.gz 
sudo ./teleport/install 
sudo cp ./teleport/examples/systemd/production/node/teleport.service /etc/systemd/system/
sudo systemctl enable teleport
echo "creating health script"
sudo mkdir /etc/health
sudo cp etc-health.sh /etc/health/health.sh
sudo touch /etc/health/cameras.info
sudo chmod u+x /etc/health/health.sh 
sudo /usr/bin/shc -f /etc/health/health.sh
sleep 3
sudo cp /etc/health/health.sh.x /bin/health
echo "updating rc.local"
sudo echo 'dtoverlay=disable-bt' | sudo tee -a  /boot/config.txt 
sudo sed -i 's/exit 0//' /etc/rc.local
sudo echo 'iwconfig wlan0 power off' | sudo tee -a  /etc/rc.local
sudo echo 'sysctl -w net.ipv6.conf.all.disable_ipv6=1' | sudo tee -a  /etc/rc.local
sudo echo 'sysctl -w net.ipv6.conf.default.disable_ipv6=1' | sudo tee -a  /etc/rc.local
sudo echo 'sysctl -w net.ipv6.conf.lo.disable_ipv6=1' | sudo tee -a  /etc/rc.local
sudo echo 'exit 0' | sudo tee -a  /etc/rc.local
echo "update sshd port"
sudo sed -i 's/#Port 22/Port 2222/' /etc/ssh/sshd_config
sudo systemctl enable ssh
sudo systemctl start ssh
mkdir /home/nvidia/sq_home_edge01
cd /home/nvidia/
echo "extracting conf files and keys"
tar xvpf ./raspberrypi/raspi-edge-files.tar
echo "adding cron for user nvidia for copying files to jetson"
echo '*/5 7-20 * * 1-6 ~/cp-cam-images.sh | tee -a /tmp/cam-copy.log' | sudo tee -a  /var/spool/cron/crontabs/nvidia
sudo chmod 600 /var/spool/cron/crontabs/nvidia
sudo chown nvidia:crontab /var/spool/cron/crontabs/nvidia
echo "upgrading pi"
sudo apt upgrade -y
echo "####################"
echo "###Run manually#####"
echo "##enable teleport###"
echo "####################"
