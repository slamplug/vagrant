# Class: java
#
# Installs java distro.

class java (
  $type        = $java::params::type,
  $arch        = $java::params::arch,
  $version     = $java::params::version,
  $source_path = $java::params::source_path

) inherits java::params {

  $jdk_file        = $java::params::jdk_file
  $java_dir        = $java::params::java_dir
  $jvm_path        = $java::params::jvm_path
  $unrar_command   = $java::params::unrar_command
  $exec_javalink   = $java::params::exec_javalink
  $exec_javawslink = $java::params::exec_javawslink
  $exec_javaclink  = $java::params::exec_javaclink
  
  $download_dir = '/tmp/java'
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  
  # create download directory
  exec { "create ${download_dir} directory":
    command => "mkdir -p ${download_dir}",
    unless  => "test -d ${download_dir}",
    path    => $path,
    user    => $user,
  }

  # check download directory
  if !defined(File[$download_dir]) {
    file { $download_dir:
      ensure  => directory,
      require => Exec["create ${download_dir} directory"],
      replace => false,
      mode    => '0777',
    }
  }

  # download .gz file to VM
  file { "${download_dir}/${jdk_file}":
    ensure  => file,
    source  => "${source_path}/${jdk_file}",
    require => File[$download_dir],
    replace => false,
    mode    => '0777',
  }
  
  file { "${jvm_path}":
    ensure => directory,
    mode   => '755',
    owner  => 'root',
  }
  
  exec { "untar_jdk":
    command => "tar -zvxf ${source_path}/${jdk_file}",
    path    => $path,
    unless  => "test -e ${jvm_path}/${type}1.7.0_${version}",
    cwd     => $jvm_path,
    require => File[ "${download_dir}/${jdk_file}" ],
  }
  
  exec {'java_link':
    command => $exec_javalink,
    path    => $path,
    require => Exec [ "untar_jdk" ]
  }
  
  exec {'javaws_link':
    command => $exec_javawslink,
    path    => $path,
    require => Exec [ "untar_jdk" ]
  }
  
  exec {'javac_link':
    command => $exec_javaclink,
    path    => $path,
    require => Exec [ "untar_jdk" ]
  }  
}