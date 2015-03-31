# Deploying Java spring.io microservices using docker with slugs

# Instructions

# General

1. Install vagrant on the host.
2. gt clone --recursive https://github.com/slamplug/vagrant.git

# Build Server

1. cd into vagrant directory
2. vagrant build up
3. Once started the following needs to be added to the sudoers file

   jenkins    ALL=NOPASSWD: /usr/bin/docker
   
4. Set up jenkins jobs. Jenkins is accessed on http://192.168.56.10/. 
   Jenkins config has been backed up at vagrant/build/jenkins.
   Will need SSH keys for GitHub.
   Reqire the following additional plugins.
     - Jenkins GIT client Plugin
	 - GitHub API Plugin
	 - Jenkins GIT Plugin
	 - Github Plugin
	 - Build with Parameters Plugin
	 - Jenkins Parametrized Trigger Plugin
	 - Show Buold Parameters Plugin
	 - ThinBackup

Jenkins jobs build slugs and secure these in local NGINX serverd directory. These could go in Nexus instead.
Jenkins container refresh job removes any existing container, then starts new docker container.
  

