grep -v ^# /etc/health/cameras.info | awk '{print $1}' | while read ip; do curl -o /tmp/$ip.jpg http://$ip/capture ; done
