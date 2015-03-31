# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.define :build do |build_config|

    build_config.vm.box = "ubuntu-saucy64"
    build_config.vm.host_name = "build"
    build_config.vm.network "private_network", ip: "192.168.56.10"

    build_config.vm.provision :shell, :inline => "apt-get -y install dos2unix"
    build_config.vm.provision :shell, :inline => "cp -r /vagrant/.ssh/* /home/vagrant/.ssh/."
    build_config.vm.provision :shell, :inline => "chmod 600 /home/vagrant/.ssh/id_rsa"
    build_config.vm.provision :shell, :inline => "cd /vagrant/build; dos2unix bootstrap.sh; echo vagrant | sudo -S ./bootstrap.sh"
 
    #config.vm.provider :virtualbox do |vb|
    #    vb.customize ["modifyvm", :id, "--memory", "2048"]
    #    vb.customize ["modifyvm", :id, "--cpus", "2"]
    #end
  end
end
