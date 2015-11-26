# Class: nginx
#
# Installs and configures nginx

class nginx (
   $conf_file             = '/vagrant/puppet/modules/nginx/files/nginx.conf',
   $default_site          = '/vagrant/puppet/modules/nginx/files/default',
   $install_apache2_utils = 'false',
   $create_index          = undef
) {

  if ($install_apache2_utils == 'false') {
    $apt_packages = [ 'nginx' ]
  } else {
    $apt_packages = [ 'nginx', 'apache2-utils' ]
  }
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }
  service { 'nginx':
    ensure  => 'running',
    enable  => 'true',
    require => Package[ $apt_packages ]
  } 
  
  file { '/etc/nginx/nginx.conf':
    ensure  => 'present',
    source  => $conf_file,
    notify  => Service['nginx'],
    require => Package[ $apt_packages ],
  }
  
  exec { 'htpasswd-kibana':
    command => "/usr/bin/htpasswd -b -c /etc/nginx/htpasswd.users kibanaadmin password",
    notify  => Service['nginx'],
    require => Package[ $apt_packages ],
    onlyif  => '/usr/bin/test -f /usr/bin/htpasswd',
  }
  
  file { '/etc/nginx/sites-available/default':
    ensure => 'present',
    source => $default_site,
    notify => Service['nginx'],
    require => Package[ $apt_packages ],
  }
  
  if ($create_index) {
    file { ['/build', '/build/nexus']:
      ensure  => 'directory',
      require => Package[ $apt_packages ],
      mode    => '777',
    }
    
    file { '/build/nexus/index.html':
      ensure  => 'present',
      source  => '/vagrant/puppet/modules/nginx/files/index.html',
      notify  => Service['nginx'],
      require => [ File['/build', '/build/nexus'], Package[ $apt_packages ] ],
    }
  } 
}

