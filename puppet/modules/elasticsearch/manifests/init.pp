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
    owner   => 'elasticsearch',
    group   => 'elasticsearch',
    notify  => Service['elasticsearch'],
    require => Package[ $apt_packages ]
  }
}