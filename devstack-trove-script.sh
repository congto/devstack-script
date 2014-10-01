###
#!/bin/bash -ex
###################################################
#@ Tested: 30/09/2014
#@ Two NICs: eth0 - Inteter , eth1 - MGNT 
#@ SHA: c3f498d36a3951a055048e52d546616a3c7a2d14
###################################################

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
# su - stack
git clone -b stable/icehouse  https://github.com/openstack-dev/devstack.git  && cd devstack 


eth1_address=`/sbin/ifconfig eth1 | awk '/inet addr/ {print $2}' | cut -f2 -d ":" `
PASSTEST=Welcome123

echo "##### Khai bao file localrc #####"
sleep 3
cat <<EOF>> localrc

###IP Configuration
HOST_IP=$eth1_address

#Credentials
ADMIN_PASSWORD=$PASSTEST
MYSQL_PASSWORD=$PASSTEST
RABBIT_PASSWORD=$PASSTEST
SERVICE_PASSWORD=$PASSTEST
SERVICE_TOKEN=$PASSTEST
 

####Tempest
enable_service tempest

##Neutron
enable_service neutron
disable_service n-net
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta

###Trove
enable_service trove,tr-api,tr-tmgr,tr-cond

#Log Output
LOGFILE=/opt/stack/logs/stack.sh.log
VERBOSE=True
LOG_COLOR=False
SCREEN_LOGDIR=/opt/stack/logs
EOF
./stack.sh
