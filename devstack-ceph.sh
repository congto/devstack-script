##################
#!/bin/bash -ex
##################

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
cat <<EOF>> local.conf


###IP Configuration
HOST_IP=$eth1_address

#Credentials
ADMIN_PASSWORD=$PASSTEST
MYSQL_PASSWORD=$PASSTEST
RABBIT_PASSWORD=$PASSTEST
SERVICE_PASSWORD=$PASSTEST
SERVICE_TOKEN=$PASSTEST
 
##Neutron
enable_service neutron
disable_service n-net
enable_service q-svc
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta
# DISABLED_SERVICES=n-net
# ENABLED_SERVICES+=,q-svc,q-agt,q-dhcp,q-l3,q-meta,q-metering,neutron

# Prerequisite
ENABLED_SERVICES=rabbit,mysql,key
 
# Ceph!
ENABLED_SERVICES+=,ceph
CEPH_LOOPBACK_DISK_SIZE=10G
CEPH_CONF=/etc/ceph/ceph.conf
CEPH_REPLICAS=1
 
# Glance - Image Service
ENABLED_SERVICES+=,g-api,g-reg
GLANCE_CEPH_USER=glancy
GLANCE_CEPH_POOL=imajeez
 
# Cinder - Block Device Service
ENABLED_SERVICES+=,cinder,c-api,c-vol,c-sch,c-bak
CINDER_DRIVER=ceph
CINDER_CEPH_USER=cindy
CINDER_CEPH_POOL=volumeuh
CINDER_CEPH_UUID=6d52eb95-12f3-47e3-9eb9-0c1fe4142426
CINDER_BAK_CEPH_POOL=backeups
CINDER_BAK_CEPH_USER=cind-backeups
CINDER_ENABLED_BACKENDS=ceph,lvm
 
# Nova - Compute Service
# ENABLED_SERVICES+=,n-api,n-crt,n-cpu,n-cond,n-sch,n-net
NOVA_CEPH_POOL=vmz
 
#Log Output
# LOGFILE=/opt/stack/logs/stack.sh.log
# VERBOSE=True
# LOG_COLOR=False
# SCREEN_LOGDIR=/opt/stack/logs

EOF

./stack.sh
