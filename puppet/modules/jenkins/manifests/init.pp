# Class: jenkins
#
# Installs and configures jenkins

class jenkins (

  $jenkins_master = true

) {

  require java

  if ($jenkins_master == true) {
  
    exec { 'add-jenkins-apt-key':
      command => "/usr/bin/wget -q -O - https://jenkins-ci.org/debian/jenkins-ci.org.key | /usr/bin/apt-key add -"
    }
    exec { 'add-jenkins-to-sources':
      command => "/bin/sh -c '/bin/echo deb http://pkg.jenkins-ci.org/debian binary/ > /etc/apt/sources.list.d/jenkins.list'",
      require => Exec[ 'add-jenkins-apt-key' ]
    }
    exec { 'apt-update-jenkins':
      command => "/usr/bin/apt-get update",
      require => Exec[ 'add-jenkins-to-sources' ]
    }
  
    Exec["apt-update-jenkins"] -> Package <| |>
  
    $apt_packages = [ 'jenkins', 'unzip', 'git' ]
  
    package { $apt_packages:
      ensure   => 'installed',
      provider => 'apt',
    }
    
    service { 'jenkins':
      ensure  => 'running',
      enable  => 'true',
      require => Package[ $apt_packages ]
    }    
  
    file { '/tmp/jenkins':
      ensure => 'directory',
    }
    
    exec { 'unzip_jenkins_home':
      command => '/usr/bin/unzip -oq /vagrant/puppet/modules/jenkins/files/jenkins_home.zip -d /tmp/jenkins',
      require => [ Package[ $apt_packages ], File[ '/tmp/jenkins'] ]
    }
      
    file { '/var/lib/jenkins':
      ensure   => 'present',
      source   => '/tmp/jenkins/jenkins_home',
      recurse  => 'true',
      require  => Exec[ 'unzip_jenkins_home' ],
      notify   => Service[ 'jenkins' ],
      owner    => 'jenkins',
      group    => 'jenkins',
    } 
      
    exec { 'set-jenkins-git-user-email':
      user        => 'jenkins',
      environment => 'HOME=/var/lib/jenkins',
      command     => '/usr/bin/git config --global user.email "jenkins@example.com"',
      require     => Package[ $apt_packages ]
    }

    exec { 'set-jenkins-git-user-name':
      user        => 'jenkins',
      environment => 'HOME=/var/lib/jenkins',
      command     => '/usr/bin/git config --global user.name "jenkins"',
      require     => Package[ $apt_packages ]
    }

  } else {
  
    group { 'jenkins':
      ensure => 'present'
    }->
    user { 'jenkins':
      ensure => 'present',
      groups => 'jenkins',
      home   => '/var/lib/jenkins'
    }->
    file { '/var/lib/jenkins':
      ensure => 'directory',
      owner  => 'jenkins',
      group  => 'jenkins'
    }->
    file { '/var/lib/jenkins/.ssh':
      ensure => 'directory',
      owner  => 'jenkins',
      group  => 'jenkins',
      mode   => '700'
    }->
    file { '/var/lib/jenkins/containers':
      ensure => 'directory',
      owner  => 'jenkins',
      group  => 'jenkins'
    }->
    file { '/var/lib/jenkins/.ssh/id_rsa':
      ensure => 'present',
      owner  => 'jenkins',
      group  => 'jenkins',
      mode   => '600',
      source => '/vagrant/puppet/modules/jenkins/files/id_rsa'
    }->
    file { '/var/lib/jenkins/.ssh/id_rsa.pub':
      ensure => 'present',
      owner  => 'jenkins',
      group  => 'jenkins',
      mode   => '755',
      source => '/vagrant/puppet/modules/jenkins/files/id_rsa.pub'
    }->
    file { '/var/lib/jenkins/.ssh/authorized_keys':
      ensure => 'present',
      owner  => 'jenkins',
      group  => 'jenkins',
      mode   => '640',
      source => '/vagrant/puppet/modules/jenkins/files/authorized_keys'
    }
  }

  exec { 'add-jenkins-to-sudoers':
    command => '/bin/echo "jenkins    ALL=NOPASSWD: /usr/bin/docker" >> /etc/sudoers',
    unless  => '/bin/grep jenkins /etc/sudoers',
  }

}