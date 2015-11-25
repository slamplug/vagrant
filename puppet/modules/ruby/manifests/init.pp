# Class: ruby
#
# Installs and configures ruby

class ruby (
  $pull_slugbuilder  = 'true',
  $sudoer_user       = 'jenkins'
  
) {

  $apt_packages = [ 'curl' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }
  
  exec { 'curl-gpg-key':
    command => '/usr/bin/curl -sSL https://rvm.io/mpapis.asc | gpg --import -',
    require => Package[ $apt_packages ]
  }-> 
  exec { 'install-rvm':
    command => '/usr/bin/curl -L https://get.rvm.io | bash -s stable'
  }->
  exec { 'rvm-requirements':
    command =>  "/bin/bash --login -c '/usr/local/rvm/bin/rvm requirements'"
  }->
  exec { 'install-ruby':
    command => "/bin/bash --login -c '/usr/local/rvm/bin/rvm install ruby && /usr/local/rvm/bin/rvm use ruby --default'"
  } 
}