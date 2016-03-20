#!/bin/bash -x

bridge_dir=/var/lib/sigul
rm -rf $bridge_dir/* ; mkdir -p $bridge_dir
certutil -N -d $bridge_dir
certutil -S -d $bridge_dir -n my-ca -s "CN=bridge-CA" -t CT,, -x -v 120
certutil -S -d $bridge_dir -n sigul-bridge-cert -s "CN=$(hostname -f)" -c my-ca -t u,, -v 120
chown sigul:sigul $bridge_dir/*.db

# https://access.redhat.com/documentation/en-US/Red_Hat_Directory_Server/9.0/html/Administration_Guide/Managing_SSL-Using_certutil.html
certutil -d $bridge_dir -L -n my-ca -a > $bridge_dir/cacert.asc

certutil -K -d $bridge_dir
certutil -L -d $bridge_dir
