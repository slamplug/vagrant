#!/bin/sh

echo "install tools first"
dpkg -s wget 2>/dev/null >/dev/null || apt-get -y install wget
dpkg -s curl 2>/dev/null >/dev/null || apt-get -y install curl

echo "install and configure elasticsearch"
wget -O - http://packages.elasticsearch.org/GPG-KEY-elasticsearch | apt-key add -
echo 'deb http://packages.elasticsearch.org/elasticsearch/1.4/debian stable main' | tee /etc/apt/sources.list.d/elasticsearch.list
apt-get update
apt-get -y install elasticsearch=1.4.4
cp /vagrant/elk/elasticsearch/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart
update-rc.d elasticsearch defaults 95 10

echo "install and configure kibana"
cd /tmp && wget https://download.elasticsearch.org/kibana/kibana/kibana-4.0.1-linux-x64.tar.gz
cd /opt && sudo tar zxf /tmp/kibana-4.0.1-linux-x64.tar.gz
mv /opt/kibana-4.0.1-linux-x64 /opt/kibana
cp /vagrant/elk/kibana/kibana.yml /opt/kibana/config/kibana.yml
cd /etc/init.d && wget https://gist.githubusercontent.com/thisismitch/8b15ac909aed214ad04a/raw/bce61d85643c2dcdfbc2728c55a41dab444dca20/kibana4
chmod +x /etc/init.d/kibana4
update-rc.d kibana4 defaults 96 9
service kibana4 start

echo "install and configure nginx"
apt-get -y install -y nginx apache2-utils
htpasswd -b -c /etc/nginx/htpasswd.users kibanaadmin password
cp /vagrant/elk/nginx/default /etc/nginx/sites-available/default
service nginx restart

echo "install and configure logstash"
echo 'deb http://packages.elasticsearch.org/logstash/1.5/debian stable main' | tee /etc/apt/sources.list.d/logstash.list
apt-get update && apt-get install logstash
mkdir -p /etc/pki/tls/certs/ && \
  cp /vagrant/elk/logstash/lumberjack.crt /etc/pki/tls/certs/lumberjack.crt
mkdir -p /etc/pki/tls/private/ && \
  cp /vagrant/elk/logstash/lumberjack.key /etc/pki/tls/private/lumberjack.key
cp /vagrant/elk/logstash/01-lumberjack-input.conf /etc/logstash/conf.d/01-lumberjack-input.conf && \
  cp /vagrant/elk/logstash/30-lumberjack-output.conf /etc/logstash/conf.d/30-lumberjack-output.conf
service logstash restart
