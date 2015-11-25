# Class: elasticsearch
#
# Installs and configures elasticsearch

class elasticsearch () {

  require java

  exec { 'add-elasticsearch-apt-key':
   command => "/usr/bin/wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -"
  }
  exec { 'add-elasticsearch-to-sources':
    command => "/bin/sh -c '/bin/echo deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main > /etc/apt/sources.list.d/elasticsearch.list'",
    require => Exec[ 'add-elasticsearch-apt-key' ]
  }
  exec { 'apt-update-elasticsearch':
    command => "/usr/bin/apt-get update",
    require => Exec[ 'add-elasticsearch-to-sources' ]
  }
  
  Exec["apt-update-elasticsearch"] -> Package <| |>
  
  $apt_packages = [ 'elasticsearch' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
    install_options => [ '1.4.4' ]
  }
  
  service { 'elasticsearch':
    ensure  => 'running',
    enable  => 'true',
    require => Package[ $apt_packages ]
  }
  
  file { '/etc/elasticsearch/elasticsearch.yml':
    ensure  => 'present',
    source  => '/vagrant/puppet/modules/elasticsearch/files/elasticsearch.yml',
    notify  => Service['elasticsearch'],
    require => Package[ $apt_packages ]
  }

}

#echo "install and configure elasticsearch"
#wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
#echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list
#apt-get update
#apt-get -y install elasticsearch=1.4.4
#cp /vagrant/elk/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
#service elasticsearch restart
#update-rc.d elasticsearch defaults 95 10