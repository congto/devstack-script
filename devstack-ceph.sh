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

[[local|localrc]]
ADMIN_PASSWORD=luonggia
DATABASE_PASSWORD=$ADMIN_PASSWORD
RABBIT_PASSWORD=$ADMIN_PASSWORD
SERVICE_PASSWORD=$ADMIN_PASSWORD
SERVICE_TOKEN=a682f596-76f3-11e3-b3b2-e716f9080d50
LOGFILE=$DEST/logs/stack.sh.log
SCREEN_LOGDIR=$DEST/logs/screen

# MULTI_HOST=True

enable_service mysql
#enable_service postgresql

disable_service n-net
enable_service q-svccd
enable_service q-agt
enable_service q-dhcp
enable_service q-l3
enable_service q-meta
enable_service neutron

enable_service s-proxy s-object s-container s-account
SWIFT_HASH=$ADMIN_PASSWORD

#enable_service c-bak

enable_service n-novnc
enable_service n-xvnc 

# Ceph 

ENABLED_SERVICES+=,ceph
CEPH_LOOPBACK_DISK_SIZE=10G
CEPH_CONF=/etc/ceph/ceph.conf
CEPH_REPLICAS=1

# Glance
ENABLED_SERVICES+=,g-api,g-reg
GLANCE_CEPH_USER=glancy
GLANCE_CEPH_POOL=image

# Cinder
ENABLED_SERVICES+=,cinder,c-api,c-vol,c-sch,c-bak
CINDER_DRIVER=ceph
CINDER_CEPH_USER=cindy
CINDER_CEPH_POOL=volume
CINDER_CEPH_UUID=6d52eb95-12f3-47e3-9eb9-0c1fe4142426
CINDER_BAK_CEPH_USER=backy
CINDER_BAK_CEPH_POOL=backup
CINDER_ENABLED_BACKENDS=ceph,1vm

# Nova
ENABLED_SERVICES+=,n-api,n-crt,n-cpu,n-cond,n-sch,n-net
NOVA_CEPH_POOL=vmz
EOF

./stack.sh
