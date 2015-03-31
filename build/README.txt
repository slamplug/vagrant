Need to add the following into sudoers file

jenkins    ALL=NOPASSWD: /usr/bin/docker

build slug
/usr/bin/git archive origin/master | sudo /usr/bin/docker run -i -a stdin -a stdout flynn/slugbuilder - > /build/nexus/stub-app-SNAPSHOT.tgz

run slug
$id=(sudo docker run -p 8080:8080 -e SLUG_URL=http://192.168.56.10/nexus/stub-app-SNAPSHOT.tgz -d -i -t flynn/slugrunner start web)
give us container id

vagrant@build:~$ sudo docker stop 3e5165a44322db77d4bff12eeb586a00388448748e98ca705ad11d0584259a87
3e5165a44322db77d4bff12eeb586a00388448748e98ca705ad11d0584259a87
vagrant@build:~$ sudo docker rm 3e5165a44322db77d4bff12eeb586a00388448748e98ca705ad11d0584259a87
3e5165a44322db77d4bff12eeb586a00388448748e98ca705ad11d0584259a87


