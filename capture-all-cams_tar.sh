grep -v ^# /etc/health/cameras.info | awk '{print $1}' > /tmp/camips.list
grep -v ^# /etc/health/cameras.info | awk '{print $1"-"$2}' > /tmp/campos.list
rm /tmp/jpg$HOSTNAME.tar
cp -r /tmp/jpg /tmp/jpg.1
rm -rf /tmp/jpg
mkdir /tmp/jpg
grep -v ^# /etc/health/cameras.info | awk '{print $1}' | while read ip; do curl -o /tmp/jpg/`grep $ip /tmp/campos.list`.jpg -m 5 -s -w "%{http_code}\n" http://$ip/capture  && echo $ip IS UP || echo $ip IS DOWN  ; done
cd /tmp/jpg
tar cvf /tmp/jpg$HOSTNAME.tar ./
ls -hl /tmp/jpg$HOSTNAME.tar
