cp /etc/hosts ./
IPADDR=`ifconfig eth0|grep inet|head -n1|awk -F ':' '{print $2}'|awk '{print $1}'`

echo "$IPADDR    `hostname`" >> hosts.tmp
sudo cp hosts.tmp /etc/hosts

