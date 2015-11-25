# Class: logstash
#
# Installs and configures logstash

class logstash () {

  require java

  exec { 'add-logstash-to-sources':
    command => "/bin/sh -c '/bin/echo deb http://packages.elasticsearch.org/logstash/1.5/debian stable main > /etc/apt/sources.list.d/logstash.list'"
  }
  exec { 'apt-update-logstash':
    command => "/usr/bin/apt-get update",
    require => Exec[ 'add-logstash-to-sources' ]
  }
  
  Exec["apt-update-logstash"] -> Package <| |>
  
  $apt_packages = [ 'logstash' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt'
  }
  
  service { 'logstash':
    ensure  => 'running',
    enable  => 'true',
    require => Package[ $apt_packages ]
  }
  
  file { ['/etc/pki', '/etc/pki/tls', '/etc/pki/tls/certs', '/etc/pki/tls/private' ]:
    ensure => directory
  }->
  file { '/etc/pki/tls/certs/lumberjack.crt':
    ensure  => 'present',
    source  => '/vagrant/puppet/modules/logstash/files/lumberjack.crt',
    notify  => Service['logstash'],
    require => Package[ $apt_packages ]
  }->
  file { '/etc/pki/tls/certs/lumberjack.key':
    ensure  => 'present',
    source  => '/vagrant/puppet/modules/logstash/files/lumberjack.key',
    notify  => Service['logstash'],
    require => Package[ $apt_packages ]
  }
  
  file { '/etc/logstash/conf.d/01-lumberjack-input.conf':
    ensure  => 'present',
    source  => '/vagrant/puppet/modules/logstash/files/01-lumberjack-input.conf',
    notify  => Service['logstash'],
    require => Package[ $apt_packages ]
  }
  file { '/etc/logstash/conf.d/30-lumberjack-output.conf':
    ensure  => 'present',
    source  => '/vagrant/puppet/modules/logstash/files/30-lumberjack-output.conf',
    notify  => Service['logstash'],
    require => Package[ $apt_packages ]
  }
}