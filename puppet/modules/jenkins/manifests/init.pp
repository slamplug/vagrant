# Class: jenkins
#
# Installs and configures jenkins

class jenkins {

  require java

  exec { "add-jenkins-apt-key":
    command => "/usr/bin/wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/apt-key add -"
  }
  exec { "add-jenkins-to-sources":
    command => "/bin/sh -c '/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'",
    require => Exec[ 'add-jenkins-apt-key' ]
  }
  exec { "apt-update":
    command => "/usr/bin/apt-get update",
    require => Exec[ 'add-jenkins-to-sources' ]
  }
  
  Exec["apt-update"] -> Package <| |>
  
  $apt_packages = [ 'jenkins', 'unzip' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }
  
  service { 'jenkins':
    ensure => 'running'
  }
  
  exec { "unzip_jenkins_home":
    command => "/usr/bin/unzip -o /vagrant/puppet/modules/jenkins/files/jenkins_home.zip -d /var/lib/jenkins",
    require => Package[ $apt_packages ]
  }->
  exec { "delete_last_successful":
    command => "/usr/bin/find /var/lib/jenkins/jobs -name lastSuccessful -exec rm -rf 2>/dev/null {} \\;"  
  }->
  exec { "delete_last_stable":
    command => "/usr/bin/find /var/lib/jenkins/jobs -name lastStable -exec rm -rf 2>/dev/null {} \\;"  
  }->
  file { '/var/lib/jenkins':
    owner   => 'jenkins',
    group   => 'jenkins',
    notify  => Service['jenkins'],
  }
}