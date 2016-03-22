#!/bin/bash

echo "root:redhat" | chpasswd
echo "vagrant:redhat" | chpasswd

setenforce 0

EVANREPO=https://copr.fedorainfracloud.org/coprs/evanosaurus/sigul-the-next-generation/repo/fedora-23/evanosaurus-sigul-the-next-generation-fedora-23.repo
THISFILE=$(basename $0)
which dnf
DNFRC=$?
if [[ $DNFRC != 0 ]]; then
    yum -y install epel-release
    yum -y install vim-enhanced bind-utils tcpdump strace ltrace lsof wget
    curl -o /etc/yum.repos.d/evan.repo $EVANREPO
    yum -y install sigul
else
    dnf -y install vim-enhanced bind-utils tcpdump strace ltrace lsof wget
    curl -o /etc/yum.repos.d/evan.repo $EVANREPO
    dnf -y install sigul
fi

# Fix /etc/hosts ...
cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.100 	client.example.org client
10.0.0.10   bridge.example.org bridge
10.0.0.20   server.example.org server
EOF

cat <<EOF > /root/.vimrc
syntax enable
set expandtab
set background=dark
set tabstop=4
set shiftwidth=4
set ruler
EOF

# kill firewall
if [[ $DNFRC != 0 ]]; then
    iptables -F
    service iptables save
    service iptable stop
else
    systemctl disable firewalld
    #systemctl stop firewalld
fi



