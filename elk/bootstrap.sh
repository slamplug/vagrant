#!/bin/sh

echo "install tools first"
dpkg -s wget 2>/dev/null >/dev/null || apt-get -y install wget
dpkg -s curl 2>/dev/null >/dev/null || apt-get -y install curl

echo "install and configure logstash"
curl https://download.elasticsearch.org/logstash/logstash/logstash-1.4.0.tar.gz -o /tmp/logstash-1.4.0.tar.gz
cd /opt && sudo tar -zxvf /tmp/logstash-1.4.0.tar.gz
mkdir /etc/logstash && cp /vagrant/elk/logstash/logstash.conf /etc/logstash/logstash.conf

echo "install and configure elasticsearch"
curl https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.0.1.tar.gz -o /tmp/elasticsearch-1.0.1.tar.gz
cd /opt && sudo tar -zxvf /tmp/elasticsearch-1.0.1.tar.gz

echo "install and configure kibana"
