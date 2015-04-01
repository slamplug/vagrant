# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = 'ubuntu-saucy64'

Vagrant.configure('2') do |config|

  config.vm.define :build do |build_config|

    build_config.vm.box = BOX
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

  config.vm.define :dev do |dev_config|

    dev_config.vm.box = BOX
    dev_config.vm.host_name = "dev"
    dev_config.vm.network "private_network", ip: "192.168.56.20"

    dev_config.vm.provision :shell, :inline => "apt-get -y install dos2unix"
    dev_config.vm.provision :shell, :inline => "cp -r /vagrant/.ssh/* /home/vagrant/.ssh/."
    dev_config.vm.provision :shell, :inline => "chmod 600 /home/vagrant/.ssh/id_rsa"
    dev_config.vm.provision :shell, :inline => "cd /vagrant/dev; dos2unix bootstrap.sh; echo vagrant | sudo -S ./bootstrap.sh"
 
    #config.vm.provider :virtualbox do |vb|
    #    vb.customize ["modifyvm", :id, "--memory", "2048"]
    #    vb.customize ["modifyvm", :id, "--cpus", "2"]
    #end
  end

  config.vm.define :test do |test_config|

    test_config.vm.box = BOX
    test_config.vm.host_name = "test"
    test_config.vm.network "private_network", ip: "192.168.56.30"

    test_config.vm.provision :shell, :inline => "apt-get -y install dos2unix"
    test_config.vm.provision :shell, :inline => "cp -r /vagrant/.ssh/* /home/vagrant/.ssh/."
    test_config.vm.provision :shell, :inline => "chmod 600 /home/vagrant/.ssh/id_rsa"
    test_config.vm.provision :shell, :inline => "cd /vagrant/dev; dos2unix bootstrap.sh; echo vagrant | sudo -S ./bootstrap.sh"
 
    #config.vm.provider :virtualbox do |vb|
    #    vb.customize ["modifyvm", :id, "--memory", "2048"]
    #    vb.customize ["modifyvm", :id, "--cpus", "2"]
    #end
  end

end
