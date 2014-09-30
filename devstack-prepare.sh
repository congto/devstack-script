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
echo "##### Thiet lap IP #####"
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
auto eth0
iface eth0 inet static
address 172.16.69.160
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8

EOF

init 6

