###
#!/bin/bash -ex
####


# echo "##### Cai dat devstack #####"
# echo "##### Tao user stack #####"
# sleep 3

# useradd -m -p Welcome123 stack
# echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# echo "##### Phan vung o cung cho SDB #####"
# sleep 3
# sudo fdisk -l
# sudo pvcreate /dev/sdb
# sudo vgcreate stack-volumes /dev/sdb

echo "##### Tai cac goi can thiet #####"
sleep 3
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
address 10.10.10.50
netmask 255.255.255.0

# EXT NETWORK
auto eth0
iface eth0 inet static
address 10.145.47.60
netmask 255.255.255.0
gateway 10.145.47.1
dns-nameservers 8.8.8.8

EOF

init 6

##########
##########
