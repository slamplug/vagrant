# Class: maven
#
# Installs and configures maven

class maven {

  require java

  $apt_packages = [ 'maven' ]
  
  package { $apt_packages:
    ensure   => 'installed',
    provider => 'apt',
  }
}
