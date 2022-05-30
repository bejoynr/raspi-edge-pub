#!/bin/bash
HOMEDIR=nvidia
DATE=$(date +"%Y-%m-%d_%H%M")
SRCDIR=/home/$HOMEDIR/sq_home_edge01

# Create the camera folders if they don't exists
for i in `grep esp32 /etc/health/cameras.info | awk '{print $2}'` ; do
  if [ -d "/home/$HOMEDIR/sq_home_edge01/$HOSTNAME/$i" ]; then
    echo "Directory exixts for $i"
  else
    mkdir -p /home/$HOMEDIR/sq_home_edge01/$HOSTNAME/$i  
  fi
done

# Capture the camera image and store to the local path
for i in `grep esp32 /etc/health/cameras.info | awk '{print $2}'` ; do
  ip=`grep $i /etc/health/cameras.info |awk '{print $1}'`
  curl -m 40 -o $SRCDIR/$HOSTNAME/$i/latest.jpg $ip/capture
  sleep 2
done

# Get the Public IP list from Teleport Server
scp -i ~/.ssh/raspi-cp-privkey -P 22 nvidia@fcftport.northeurope.cloudapp.azure.com:/tmp/public.ip /tmp

# Generate a file with the list(For which SSH works) of IPs
./ssh-check.sh |grep SSH_OK |  awk '{print $1}' > public.ip.ref 

# Get the first IP from the list
SSHEDGE=`head -1 public.ip.ref`

# Copy inages to the remote Jetson
scp -pr -i ~/.ssh/raspi-cp-privkey -P 2222 $SRCDIR/$HOSTNAME nvidia@$SSHEDGE:/home/nvidia/sq_home_edge01/

# Remove the Store Folder
cd $SRCDIR/
rm -rf $HOSTNAME

# Output the details to /var/tmp/cam-copy.log
echo "Images copied to $SSHEDGE at $DATE" >> /var/tmp/cam-copy.log
