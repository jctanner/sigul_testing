# Sigul Testing Environment

## QuickStart

Follow the steps below to instantiate a 3 VM infra with all the services running. The create scripts will prompt for passwords, which should all be the same ('redhat'). On the server, when it asks for the admin username+password, choose 'admin' + 'redhat'.

1. vagrant up
2. vagrant ssh bridge
  1. sudo su - 
  2. /vagrant/sigul_helpers/bridge_create.sh
  3. systemctl start sigul_bridge
  4. tail -f /var/log/sigul_bridge.log
3. vagrant ssh server
  1. sudo su - 
  2. /vagrant/sigul_helpers/server_create.sh
  3. systemctl start sigul_server
  4. tail -f /var/log/sigul_server.log
3. vagrant ssh client
  1. sudo su - 
  2. /vagrant/sigul_helpers/client_create.sh
  3. sigul -v -v list-users
  ...
  4. sigul new-key --key-admin=admin testkey1
  5. sigul list-keys
  6. wget [rpmurl]
  7. sigul sign-rpm -o signed.rpm testkey1 [rpmfilename]


If list-users prints out a line containing only the word 'admin', the infra has been setup correctly.

The new-key function generates a gpg key which requires a fair amount of entropy. My workaround for creating the entropy was to wget [on the server] centos ISOs from ftp.linux.ncsu.edu.

## Debugging

Systemd takes a long time to kill sigul, so modify the unit file to kill it forcefully ...
````
[Unit]
Description=Sigul vault server
After=network.target
Documentation=https://fedorahosted.org/sigul/

[Service]
ExecStart=/usr/sbin/sigul_server -v -v
ExecStop=/vagrant/sigul_helpers/killsigul.sh
Type=simple

[Install]
WantedBy=multi-user.target
````

## References

https://github.com/kostyrevaa/ansible-koji-infra

http://adam.younglogic.com/2012/05/signing-certutil/

http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwi977Gz3MXLAhUDz3IKHQF0C38QFggdMAA&url=https%3A%2F%2Ffedorahosted.org%2Fsigul%2Fexport%2Ff4194813ad44f39358786adcf936ae10055e00e5%2FREADME&usg=AFQjCNHJlMAioC_wrYq8krkxmgNrHERsmQ&sig2=c_qDXOritkwzMY8d7noElA&cad=rja
