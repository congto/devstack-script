###
#!/bin/bash -ex
####

echo "##### Cai dat devstack #####"
echo "##### Tao user stack #####"
sleep 3

useradd -m -p Welcome123 stack
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

echo "##### Phan vung o cung cho SDB #####"
sleep 3
sudo fdisk -l
sudo pvcreate /dev/sdb
sudo vgcreate stack-volumes /dev/sdb

echo "##### Tai cac goi can thiet #####"
sleep 3
apt-get update -y
sudo apt-get install git -y || yum install -y git

##############
eth0_ADD=`sudo /sbin/ifconfig eth0 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
eth0_NETMASK_IP=`sudo /sbin/ifconfig eth0 | awk '/inet addr/ {print $4}' | cut -f2 -d ":"`
eth0_GATEWAY_IP=`sudo ip route list | awk '/^default/ {print $3}'`

# Dat bien cho eth1
eth1_ADD=`sudo /sbin/ifconfig eth1 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
eth1_NETMASK_IP=`sudo /sbin/ifconfig eth1 | awk '/inet addr/ {print $4}' | cut -f2 -d ":"`

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
address $eth1_ADD
netmask $eth1_NETMASK_IP

# EXT NETWORK
auto eth0
iface eth0 inet static
address $eth0_ADD
netmask $eth0_NETMASK_IP
gateway $eth0_GATEWAY_IP
dns-nameservers 8.8.8.8

#
# auto eth0
# iface eth0 inet manual
# up ifconfig \$IFACE 0.0.0.0 up
# up ip link set \$IFACE promisc on
# down ip link set \$IFACE promisc off
# down ifconfig \$IFACE down

EOF

echo "##### Khoi dong lai may #####"

init 6

