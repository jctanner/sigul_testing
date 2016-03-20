#!/bin/bash -x

rpm -e --nodeps sigul
rm -rf /etc/sigul
rm -rf /var/lib/sigul
rm -rf /usr/share/sigul

yum -y install sigul
# /etc/sigul/server.conf
sed -i.bak 's/bridge-hostname.*/bridge-hostname: bridge.example.org/' /etc/sigul/server.conf
sigul_server_create_db
RC=$?
if [[ $RC != 0 ]] || [ ! -f /var/lib/sigul/server.sqlite ] ; then
    exit $RC
fi

bridge_host=bridge.example.org
bridge_dir=~/bridge
server_dir=/var/lib/sigul

rm -rf $bridge_dir
mkdir -p $bridge_dir
scp -r root@$bridge_host:/var/lib/sigul/* $bridge_dir/.

## create nss database
#rm -rf $server_dir
#mkdir -p $server_dir
certutil -d $server_dir -N
#exit 1

#pk12util -d $bridge_dir -o ca.p12 -n my-ca
pk12util -d $server_dir -i $bridge_dir/ca.p12
certutil -d $server_dir -M -n my-ca -t CT,,
certutil -d $server_dir -S -n sigul-server-cert -s "CN=$(hostname -f)" -c my-ca -t u,, -v 120
chown sigul:sigul $server_dir/*.db

# /etc/sigul/server.conf
sed -i.bak 's/bridge-hostname.*/bridge-hostname: bridge.example.org/' /etc/sigul/server.conf

#sigul_server_create_db
sigul_server_add_admin
