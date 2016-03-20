# -*- mode: ruby -*-
# vi: set ft=ruby :

# epel7 doesn't have sigul [yet?]
usebox = 'puppetlabs/centos-6.6-64-nocm'

Vagrant.configure(2) do |config|

  # extensions install/update
  #config.vbguest.auto_update = false

  # cachier for yum downloads
  #config.cache.scope = :machine

  config.vm.define "client" do |client|
    client.vm.box = usebox
    client.vm.host_name = 'client.example.org'
    client.hostmanager.manage_guest = true
    client.vm.network "private_network", ip: "10.0.0.100"
    client.vm.provision "shell", path: "provision_client.sh"
  end

  config.vm.define "bridge" do |bridge|
    bridge.vm.box = usebox
    bridge.vm.host_name = 'bridge.example.org'
    bridge.hostmanager.manage_guest = true
    bridge.vm.network "private_network", ip: "10.0.0.10"
    bridge.vm.provision "shell", path: "provision_bridge.sh"
  end

  config.vm.define "server" do |server|
    server.vm.box = usebox
    server.vm.host_name = 'server.example.org'
    server.hostmanager.manage_guest = true
    server.vm.network "private_network", ip: "10.0.0.20"
    server.vm.provision "shell", path: "provision_server.sh"
  end

  #config.vm.define "server6" do |server6|
  #  server6.vm.box = "puppetlabs/centos-6.6-64-puppet"
  #  server6.vm.host_name = 'server6.example.org'
  #  server6.vm.network "private_network", ip: "10.0.0.26"
  #end

  #config.vm.define "koji.example.org" do |koji|
  #  koji.vm.box = "puppetlabs/centos-7.2-64-nocm"
  #  #koji.vm.network "public_network"
  #  koji.vm.network "private_network", ip: "10.0.0.30"
  #  koji.vm.host_name = 'koji.example.org'
  #  #koji.vm.provision "ansible" do |ansible|
  #  #  ansible.sudo = true
  #  #  ansible.raw_arguments = ["--diff"]
  #  #  ansible.tags = "builder"
  #  #  ansible.groups = {
  #  #    "koji_db" => ["koji.example.org"],
  #  #    "koji_ca" => ["koji.example.org"],
  #  #    "koji_hub" => ["koji.example.org"],
  #  #    "koji_web" => ["koji.example.org"],
  #  #    "koji_builder" => ["koji.example.org"]
  #  #  }
  #  #  ansible.playbook = "site.yml"
  #  #end
  #end

end
