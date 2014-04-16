cp /etc/hosts ./
IPADDR=`ifconfig eth1|grep inet|head -n1|awk '{print $2}'|sed s/addr://g`

echo "$IPADDR    `hostname`" >> hosts.tmp
sudo cp hosts.tmp /etc/hosts

