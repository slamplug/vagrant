#!/bin/sh

echo "configure nginx"
cd /etc/nginx/sites-available && rm default 2>/dev/null && rm ../sites-enabled/default 2>/dev/null
dos2unix /vagrant/build/nginx/nginx.conf
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.`date +%Y%m%d-%H%M%S`
cp /vagrant/build/nginx/nginx.conf /etc/nginx/nginx.conf
service nginx restart

echo "install ruby"
apt-get -y install curl
command curl -sSL https://rvm.io/mpapis.asc | gpg --import -
curl -L https://get.rvm.io | bash -s stable
source ~/.rvm/scripts/rvm
rvm requirements
rvm install ruby && rvm use ruby --default

echo "install docker"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D8576A8BA88D21E9
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
apt-get update
dpkg -s lxc-docker 2>/dev/null >/dev/null || apt-get -y install lxc-docker

echo "install flynn stuff"
docker pull flynn/slugrunner

echo "create jenkins user for jenkins slave"
mkdir -p /var/lib/jenkins/.ssh
groupadd jenkins
useradd -g jenkins -d /var/lib/jenkins jenkins
mkdir /var/lib/jenkins/containers
chown -R jenkins:jenkins /var/lib/jenkins

echo "add key to jenkins .ssh for slave authentication"
cp -r /vagrant/keys/* /var/lib/jenkins/.ssh/.
chmod 600 /var/lib/jenkins/.ssh/id_rsa
chmod 640 /var/lib/jenkins/.ssh/authorized_keys
chmod 700 /var/lib/jenkins/.ssh
chown -R jenkins:jenkins /var/lib/jenkins

echo "add jenkins to sudoers file"
echo "jenkins    ALL=NOPASSWD: /usr/bin/docker" >> /etc/sudoers