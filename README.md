# Sigul Testing Environment

## QuickStart

1. vagrant up
2. vagrant ssh bridge
  1. sudo su - 
  2. /vagrant/sigul_helpers/bridge_create.sh
3. vagrant ssh server
  1. sudo su - 
  2. /vagrant/sigul_helpers/server_create.sh
3. vagrant ssh client
  1. sudo su - 
  2. /vagrant/sigul_helpers/client_create.sh
  3. sigul -v -v list-users

## References

https://github.com/kostyrevaa/ansible-koji-infra

http://adam.younglogic.com/2012/05/signing-certutil/

http://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=1&ved=0ahUKEwi977Gz3MXLAhUDz3IKHQF0C38QFggdMAA&url=https%3A%2F%2Ffedorahosted.org%2Fsigul%2Fexport%2Ff4194813ad44f39358786adcf936ae10055e00e5%2FREADME&usg=AFQjCNHJlMAioC_wrYq8krkxmgNrHERsmQ&sig2=c_qDXOritkwzMY8d7noElA&cad=rja
