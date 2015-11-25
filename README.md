# Deploying Java spring.io microservices using docker with slugs

# Instructions

## General

1. Install vagrant on the host.
2. gt clone https://github.com/slamplug/vagrant.git
3. Download Oracle JDK jdk-7u79-linux-x64.gz and copy to vagrant/puppet/modules/java/files/jdk-7u79-linux-x64.gz

## Starting Vagrant VM's

vagrant up build
vagrant up dev
vagrant up test
vagrant up elk

### build

jenkins build/Nexus server
hostname: build
IP: 192.168.56.10

### dev

development test server
hostname: dev
IP: 192.168.56.20

### build

system test server
hostname: test
IP: 192.168.56.30

### build

logstash/elasticsearch/kibana server
hostname: build
IP: 192.168.56.10


### 5 types of build jobs

- Snapshot builds. Produce -SNAPSHOT.tgz files.
-- Files are located in /build/nexus
-- Files served by NGINX
-- TODO: Upload/retrieve files from Nexus (nice to have)
-- triggers snapshot deploy

- Snapshot deploy. Produce -SNAPSHOT.tgz files.
-- Retrieve files using http:// protocol
-- Job executes on Jenkins slave on dev host
-- Remove existing container
-- Starts new container

- Release
-- runs mvn release:prepare to tag in GIT
-- triggers release build

- Release builds. Produce tagged tgz files. (
-- Files are located in /build/nexus
-- Files served by NGINX
-- TODO: Upload/retrieve files from Nexus (nice to have)

- Release deploy. Produce -SNAPSHOT.tgx files.
-- Retrieve files using http:// protocol
-- Job executes on Jenkins slave on test host
-- Remove existing container
-- Starts new container

