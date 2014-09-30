##
#!/bin/bash -ex
##########################3
#@ Thuc thi sau khi cai dat openstack xong

eth0_address=`sudo /sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
NETMASK_IP=`sudo /sbin/ifconfig eth0 | awk '/inet addr/ {print $4}' | cut -f2 -d ":"`
GATEWAY_IP=`sudo ip route list | awk '/^default/ {print $3}'`

echo "##### Thiet lap IP #####"
sleep 3

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
touch $ifaces
cat << EOF >> $ifaces
#Dat IP cho Controller node

# LOOPBACK NET 
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth1
iface eth1 inet static
address 10.10.10.160
netmask 255.255.255.0

# EXT NETWORK
auto br-ex
iface br-ex inet static
address $eth0_address
netmask $NETMASK_IP
gateway $GATEWAY_IP
dns-nameservers 8.8.8.8

#
auto eth0
iface eth0 inet manual
up ifconfig \$IFACE 0.0.0.0 up
up ip link set \$IFACE promisc on
down ip link set \$IFACE promisc off
down ifconfig \$IFACE down

EOF

##
echo "##### Thuc hien add port cho OVS #####"
sleep 3
sudo ovs-vsctl add-port br-ex eth0

echo "##### Khoi dong lai may chu #####"
sleep 3
init 6
