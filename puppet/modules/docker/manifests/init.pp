# Class: docker
#
# Installs and configures docker

class docker (
  $pull_slugbuilder  = 'true',
  $sudoer_user       = 'jenkins'
  
) {

  exec { 'add-docker-apt-key':
    command => "/usr/bin/apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D"
  }
  exec { 'add-docker-to-sources':
    command => "/bin/sh -c '/bin/echo deb https://apt.dockerproject.org/repo ubuntu-trusty main > /etc/apt/sources.list.d/docker.list'",
    require => Exec[ 'add-docker-apt-key' ]
  }
  exec { 'apt-update-docker':
    command => "/usr/bin/apt-get update",
    require => Exec[ 'add-docker-to-sources' ]
  }
  
  Exec["apt-update-docker"] -> Package <| |>

  $apt_packages = [ 'docker-engine' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }

  service { 'docker':
    ensure     => 'running',
    enable     => 'true',
    require    => Package[ $apt_packages ],
  }
    
  if ($pull_slugbuilder == 'true') {
    exec { 'pull-slugbuilder':
      command => '/usr/bin/docker pull flynn/slugbuilder',
      require => Package[ $apt_packages ]
    }
  }
  exec { 'pull-slugrunner':
    command => '/usr/bin/docker pull slamplug/slugrunner',
    require => Package[ $apt_packages ]
  } 
}