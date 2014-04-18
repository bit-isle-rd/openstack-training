IPADDR=`ifconfig eth0|grep inet|head -n1|awk -F ':' '{print $2}'|awk '{print $1}'`

sed s/#my_ip#/$IPADDR/g localrc.template >localrc


