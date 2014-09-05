devstack-script
===============

Các script dành cho devstack

### Thiết lập IP cho các máy chạy OpenStack bằng đoạn lệnh dưới 

```sh

ifaces=/etc/network/interfaces
test -f $ifaces.orig || cp $ifaces $ifaces.orig
rm $ifaces
cat << EOF > $ifaces
#Dat IP cho Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# EXT NETWORK
auto eth0
iface eth0 inet static
address 172.16.69.22
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8

# DATA NETWORK
auto eth1
iface eth1 inet static
address 10.10.10.22
netmask 255.255.255.0
EOF
```
- Khởi động lại máy sau khi thiết lập IP tĩnh
```sh
init 6
```
### Thực hiện các bước trước khi cài devstack
```sh 
adduser stack
echo "stack ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers
```
- Chuyển sang tài khoản stack vừa tạo ở trên và tải các gói
```sh
su - stack
sudo apt-get install git -y || yum install -y git
git clone https://github.com/openstack-dev/devstack.git && cd devstack 
```
- Tải các file local.conf mẫu và đổi tên bằng lệnh
```sh
wget http://link_file_local.conf_mau -O local.conf
```
