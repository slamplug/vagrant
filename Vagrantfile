# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX = 'ubuntu/trusty64'

$script = <<SCRIPT
cp -r /vagrant/.ssh/* /home/vagrant/.ssh/. && chmod 600 /home/vagrant/.ssh/id_rsa
SCRIPT

Vagrant.configure('2') do |config|

  config.vm.define :build do |build_config|

    build_config.vm.box = BOX
    build_config.vm.host_name = "build"
    build_config.vm.network "private_network", ip: "192.168.56.10"

    build_config.vm.provision "puppet" do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.module_path       = "puppet/modules"
      puppet.hiera_config_path = "puppet/hiera.yaml"
    end
 
    build_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.define :dev do |dev_config|

    dev_config.vm.box = BOX
    dev_config.vm.host_name = "dev"
    dev_config.vm.network "private_network", ip: "192.168.56.20"

    dev_config.vm.provision "puppet" do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.module_path       = "puppet/modules"
      puppet.hiera_config_path = "puppet/hiera.yaml"
    end
 
    dev_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.define :test do |test_config|

    test_config.vm.box = BOX
    test_config.vm.host_name = "test"
    test_config.vm.network "private_network", ip: "192.168.56.30"

    test_config.vm.provision "puppet" do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.module_path       = "puppet/modules"
      puppet.hiera_config_path = "puppet/hiera.yaml"
    end
 
    test_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end

  config.vm.define :elk do |elk_config|

    elk_config.vm.box = BOX
    elk_config.vm.host_name = "elk"
    elk_config.vm.network "private_network", ip: "192.168.56.40"

    elk_config.vm.provision "puppet" do |puppet|
      puppet.manifests_path    = "puppet/manifests"
      puppet.manifest_file     = "site.pp"
      puppet.module_path       = "puppet/modules"
      puppet.hiera_config_path = "puppet/hiera.yaml"
    end
 
    elk_config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--memory", "1024"]
    end
  end
end
