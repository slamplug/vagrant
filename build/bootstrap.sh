#!/bin/sh

echo "installing jenkins"
dpkg -s jenkins 2>/dev/null >/dev/null || apt-get -y install jenkins
service jenkins stop
unzip -o /vagrant/build/jenkins/home.zip -d /var/lib/jenkins
chown -R jenkins:jenkins /var/lib/jenkins
service jenkins start

echo "configure nginx"
cd /etc/nginx/sites-available && rm default 2>/dev/null && rm ../sites-enabled/default 2>/dev/null
dos2unix /vagrant/build/nginx/nginx.conf
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.`date +%Y%m%d-%H%M%S`
cp /vagrant/build/nginx/nginx.conf /etc/nginx/nginx.conf
[ -d /build/nexus ] || mkdir -p /build/nexus
echo "<html><body>This is where NGINX will serve static content from.</body></html>" > /build/nexus/index.html
chmod -R 777 /build/nexus
service nginx restart

echo "install docker"
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D8576A8BA88D21E9
echo "deb http://get.docker.io/ubuntu docker main" > /etc/apt/sources.list.d/docker.list
apt-get update
dpkg -s lxc-docker 2>/dev/null >/dev/null || apt-get -y install lxc-docker

echo "install flynn stuff"
docker pull flynn/slugbuilder

echo "add jenkins to sudoers file"
echo "jenkins    ALL=NOPASSWD: /usr/bin/docker" >> /etc/sudoers
