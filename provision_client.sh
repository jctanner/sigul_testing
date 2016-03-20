#!/bin/bash

yum -y install epel-release
yum -y install sigul
yum -y install vim-enhanced bind-utils tcpdump strace ltrace lsof 

#client.vm.network "private_network", ip: "10.0.0.100"
#bridge.vm.network "private_network", ip: "10.0.0.10"
#server.vm.network "private_network", ip: "10.0.0.20"

cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.100 	client.example.org client
10.0.0.10   bridge.example.org bridge
10.0.0.20   server.example.org server
EOF
