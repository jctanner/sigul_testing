#!/bin/bash

rpm -e --nodeps sigul
rm -rf /etc/sigul
rm -rf /var/lib/sigul
yum -y install sigul

client_dir=~/.sigul
rm -rf $client_dir ; mkdir -p $client_dir
ln -s /etc/sigul/client/conf $client_dir/sigul.conf

bridge_host=bridge.example.org
bridge_dir=~/bridge
mkdir -p $bridge_dir
scp -r root@$bridge_host:/var/lib/sigul/* $bridge_dir/.

certutil -d $client_dir -N

## pk12util -d $bridge_dir -o ca.p12 -n my-ca  ... do this on the bridge and copy the p12 back
pk12util -d $client_dir -i $bridge_dir/ca.p12
certutil -d $client_dir -M -n my-ca -t CT,,
  
# sigul-client-cert
certutil -d $client_dir -S -n sigul-client-cert -s "CN=$(hostname -f)" -c my-ca -t u,, -v 120 

sed -i.bak 's/bridge-hostname.*/bridge-hostname: bridge.example.org/' /etc/sigul/client.conf
sed -i.bak 's/server-hostname.*/server-hostname: server.example.org/' /etc/sigul/client.conf
sed -i.bak 's/; user-name: nobody/user-name: admin/' /etc/sigul/client.conf


# opcheck
sigul -v -v list-users

# create the vagrant user 
sigul new-user --admin --with-password vagrant
sigul -v -v list-users



