# Class: logstash
#
# Installs and configures kibana

class kibana () {

  require java

  group { 'kibana':
    ensure => 'present'
  }->
  user { 'kibana':
    ensure => 'present',
    groups => 'kibana',
    home   => '/home/kibana'
  }
      
  exec { 'wget-package':
    command => '/usr/bin/wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz',
    unless  => '/usr/bin/test -e /tmp/kibana-4.0.1-linux-x64.tar.gz',
    cwd     => '/tmp',
    require => User[ 'kibana' ]
  }->
  exec { 'untar-kibana':
    command => '/bin/tar zxf /tmp/kibana-4.0.1-linux-x64.tar.gz',
    unless  => '/usr/bin/test -e /opt/kibana-4.0.1-linux-x64',
    cwd     => '/opt',
  }->
  file{ '/opt/kibana-4.0.1-linux-x64':
    ensure  => 'directory',
    owner   => 'kibana',
    group   => 'kibana',
  }->
  file{ '/opt/kibana':
    ensure  => 'link',
    owner   => 'kibana',
    group   => 'kibana',
    target  => '/opt/kibana-4.0.1-linux-x64',
  }->
  file{ '/opt/kibana/config/kibana.yml':
    ensure  => 'link',
    owner   => 'kibana',
    group   => 'kibana',
    source  => '/vagrant/puppet/modules/kibana/files/kibana.yml'
  }->
  exec { 'wget-kibana4':
    command => '/usr/bin/wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4',
    cwd     => '/tmp',
    require => User[ 'kibana' ]
  }->
  file{ '/etc/init.d/kibana4':
    source  => '/tmp/kibana4',
    mode    => '755',
  }
  
  exec { 'update-rc-kibana4':
    command => '/usr/sbin/update-rc.d kibana4 defaults 96 9',
    require => File[ '/etc/init.d/kibana4' ]
  }
  service{ 'kibana4':
    ensure  => 'running',
    enable  => 'true',
    require => Exec[ 'update-rc-kibana4' ]
  }
}