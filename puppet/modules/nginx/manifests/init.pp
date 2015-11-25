# Class: nginx
#
# Installs and configures nginx

class nginx (
   $conf_file    = '/vagrant/puppet/modules/nginx/files/nginx.conf',
   $create_index = undef
) {

  $apt_packages = [ 'nginx' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }
  service { 'nginx':
    ensure => 'running'
  }
  
  file { '/etc/nginx/sites-available/default':
    ensure  => 'absent',
    force   => 'true',
    require => Package[ $apt_packages ]
  }->
  file { '/etc/nginx/sites-enabled/default':
    ensure => 'absent',
    force  => 'true'
  }->
  file { '/etc/nginx/nginx.conf':
    ensure => 'present',
    source => $conf_file,
    notify => Service['nginx']
  }
  
  if ($create_index) {
    file {'/build':
      ensure => 'directory'
    }->
    file {'/build/nexus':
      ensure => 'directory'
    }->
    file { '/build/nexus/index.html':
      ensure => 'present',
      source => '/vagrant/puppet/modules/nginx/files/index.html',
      notify => Service['nginx']
    }
  } 
}

