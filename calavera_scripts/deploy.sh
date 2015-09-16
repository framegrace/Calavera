#!/bin/bash
cd /var/lib/tomcat6/webapps/ROOT/WEB-INF/lib/
sudo rm CalaveraMain.*
sudo wget "http://espina:8081/artifactory/simple/ext-release-local/Calavera/target/CalaveraMain.jar" -O CalaveraMain.jar
cd /var/lib/tomcat6/webapps/ROOT/WEB-INF/
sudo rm web.xml*
sudo wget "http://espina:8081/artifactory/simple/ext-release-local/Calavera/target/web.xml" -O web.xml
sudo /etc/init.d/tomcat6 restart
