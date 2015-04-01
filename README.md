# Deploying Java spring.io microservices using docker with slugs

# Instructions

## General

1. Install vagrant on the host.
2. gt clone --recursive https://github.com/slamplug/vagrant.git

## Build Server

1. cd into vagrant directory
2. vagrant up build

hostname: build
ip: 192.168.56.10 

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

## Dev Server

1. cd into vagrant directory
2. vagrant up dev

hostname: dev
ip: 192.168.56.20
