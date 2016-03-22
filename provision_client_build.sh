#!/bin/bash

setenforce 0

THISFILE=$(basename $0)
which dnf
DNFRC=$?
if [[ $DNFRC != 0 ]]; then
    yum -y install epel-release
    #yum -y install sigul
    yum -y install vim-enhanced bind-utils tcpdump strace ltrace lsof wget
    if [[ $(hostname -f) == "bridge.example.org" ]]; then
        yum -y install gnupg rpm-build make httpd createrepo
        chkconfig httpd on
        service httpd restart
    fi
else
    #dnf -y install sigul
    dnf -y install vim-enhanced bind-utils tcpdump strace ltrace lsof wget
    if [[ $(hostname -f) == "bridge.example.org" ]]; then
        dnf -y install rpm-build python make httpd createrepo
        systemctl enable httpd
        systemctl restart httpd
    fi
fi

# Fix /etc/hosts ...
cat <<EOF > /etc/hosts
127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

10.0.0.100 	client.example.org client
10.0.0.10   bridge.example.org bridge
10.0.0.20   server.example.org server
EOF

# kill firewall
if [[ $DNFRC != 0 ]]; then
    iptables -F
    service iptables save
    service iptable stop
else
    systemctl disable firewalld
    systemctl stop firewalld
fi


################################################
# BUILD SIGUL FROM THE LATEST SRPM
################################################

if [[ $(hostname -f) == "bridge.example.org" ]]; then
    cd /root

    SRPM="sigul-0.102-3.fc24.src.rpm"
    SRPM_URL="https://kojipkgs.fedoraproject.org/packages/sigul/0.102/3.fc24/src/$SRPM"

    if [ ! -f $SRPM ]; then
        wget $SRPM_URL
    fi
    rpmbuild --rebuild $SRPM
    mkdir -p /vagrant/packages
    rm -f /vagrant/packages/sigul*.rpm
    rm -rf /var/www/html/repo ; mkdir -p /var/www/html/repo
    cp rpmbuild/RPMS/noarch/sigul*.rpm /var/www/html/repo/.
    createrepo /var/www/html/repo
    chmod -R 777 /var/www/html/repo
    sleep 2
fi

################################################
# INSTALL NEW RPM 
################################################

echo "INSTALL/UPDATE SIGUL ..."

echo '[sigulrepo]' > /etc/yum.repos.d/sigul.repo
echo 'name=sigulrepo' >> /etc/yum.repos.d/sigul.repo
echo 'baseurl=http://bridge.example.org/repo' >> /etc/yum.repos.d/sigul.repo
echo 'tolerant=1' >> /etc/yum.repos.d/sigul.repo
echo 'enabled=1' >> /etc/yum.repos.d/sigul.repo
echo 'gpgcheck=0' >> /etc/yum.repos.d/sigul.repo


rpm -e --nodeps sigul
sleep 2
if [[ $DNFRC != 0 ]]; then
    yum -y install sigul
else
    dnf clean packages
    #exit 1
    dnf -y install sigul # first try fails on bridge? why?
    dnf -y install sigul
fi
