#!/bin/bash

client_dir=~/.sigul
rm -rf $client_dir ; mkdir -p $client_dir

bridge_host=bridge.example.org
bridge_dir=~/bridge
scp -r root@$bridge_host:/var/lib/sigul/* $bridge_dir/.

certutil -d $client_dir -N

## pk12util -d $bridge_dir -o ca.p12 -n my-ca  ... do this on the bridge and copy the p12 back
pk12util -d $client_dir -i $bridge_dir/ca.p12
certutil -d $client_dir -M -n my-ca -t CT,,
  
# sigul-client-cert
certutil -d $client_dir -S -n sigul-client-cert -s "CN=$(hostname -f)" -c my-ca -t u,, -v 120 

sed -i.bak 's/bridge-hostname.*/bridge-hostname: bridge.example.org/' /etc/sigul/client.conf
sed -i.bak 's/server-hostname.*/server-hostname: server.example.org/' /etc/sigul/client.conf
sed -i.bak 's/; user-name: nobody/user-name: admin/' /etc/sigul/server.conf
