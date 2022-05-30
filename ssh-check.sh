if [ -s "$HOME/public.ip.ref" ]; then
    for host in `cat $HOME/public.ip.ref` ; do 
    ssh -q -p 2222 -o "BatchMode=yes" -i ~/.ssh/raspi-cp-privkey nvidia@$host "echo 2>&1" && echo $host SSH_OK || echo $host SSH_NOK
    done
else
    for host in `cat /tmp/public.ip` ; do 
    ssh -q -p 2222 -o "BatchMode=yes" -i ~/.ssh/raspi-cp-privkey nvidia@$host "echo 2>&1" && echo $host SSH_OK || echo $host SSH_NOK
    done
fi