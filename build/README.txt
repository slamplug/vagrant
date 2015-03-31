Need to add the following into sudoers file

jenkins    ALL=NOPASSWD: /usr/bin/docker

build slug
/usr/bin/git archive origin/master | sudo /usr/bin/docker run -i -a stdin -a stdout flynn/slugbuilder - > /build/nexus/stub-app-SNAPSHOT.tgz

run slug
sudo docker run -p 8080:8080 -e SLUG_URL=http://192.168.56.10/nexus/stub-app-SNAPSHOT.tgz -i -t flynn/slugrunner start web

