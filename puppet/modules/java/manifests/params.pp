# Class: java::params
#
# Declares distro specific variables for java class.

class java::params (
  $type     = "jdk",
  $arch     = "x64",
  $version  = "79",

){
  $jdk_file = "${type}-7u${version}-linux-${arch}.gz"
  
  $java_dir = "${type}1.7.0_${version}"
  
  $source_path = '/vagrant/puppet/modules/java/files'
  
  $path = '/usr/local/bin:/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/sbin:'
  
  $jvm_path = '/usr/lib/jvm'
  
  $unrar_command = "tar -zvxf ${source_path}/${jdk_file}"
  
  $exec_javalink = "update-alternatives --install /usr/bin/java java ${jvm_path}/${java_dir}/bin/java 1 && update-alternatives --set java ${jvm_path}/${java_dir}/bin/java"
  $exec_javawslink = "update-alternatives --install /usr/bin/javaws javaws ${jvm_path}/${java_dir}/bin/javaws 1 && update-alternatives --set javaws ${jvm_path}/${java_dir}/bin/javaws"
  $exec_javaclink = "update-alternatives --install /usr/bin/javac javac ${jvm_path}/${java_dir}/bin/javac 1 && update-alternatives --set javac ${jvm_path}/${java_dir}/bin/javac"
}