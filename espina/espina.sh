#! /usr/bin/env bash
# Espina instance
# this script is for provisioning a new Vagrant CentOS 6.5 instance for the calavera project.
# this build is for the espina project centered on Jenkins. 


###############################################################################
###########################  YUM UPDATE  ######################################
###############################################################################

# yum update
echo "updating with yum, be a few minutes..."
yum -y update

###############################################################################
#############################  JAVA  ##########################################
###############################################################################
echo "downloading Java, be a few minutes..." cd /
cd /usr/share
# not sure about the additional parameters here (e.g. --no-cookies),
# copied this syntax off the net but just using it here for Java
wget --no-cookies --no-check-certificate --header \
	"Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; \
	oraclelicense=accept-securebackup-cookie" \
	"download.oracle.com/otn-pub/java/jdk/8u25-b17/jdk-8u25-linux-i586.tar.gz" 

echo "installing Java..."
mv jdk-8u25-linux-i586.tar.gz* jdk-8u25-linux-i586.tar.gz
tar xvf jdk-8u25-linux-i586.tar.gz 

cd /usr/share/jdk1.8.0_25/

#alternatives --config java

# alternative to setting more path variables
alternatives --install /usr/bin/java java /usr/share/jdk1.8.0_25/bin/java 2
alternatives --install /usr/bin/jar jar /usr/share/jdk1.8.0_25/bin/jar 2
alternatives --install /usr/bin/javac javac /usr/share/jdk1.8.0_25/bin/javac 2
alternatives --set jar /usr/share/jdk1.8.0_25/bin/jar
alternatives --set javac /usr/share/jdk1.8.0_25/bin/javac
alternatives --set java /usr/share/jdk1.8.0_25/bin/java

rm -f /usr/share/jdk-8u25-linux-i586.tar.gz

echo "export JAVA_HOME=\"/usr/share/jdk1.8.0_25\"" >> ~/.bashrc

###############################################################################
#############################  TOMCAT  ########################################
###############################################################################


# install apache tomcat
# doing this before some other stuff so that the server is solidly running
# before we attempt the Ant build that restarts it
cd /usr/share
echo "downloading & installing Tomcat..."

# Need to create Tomcat user & group, su & install

wget http://mirrors.koehn.com/apache/tomcat/tomcat-8/v8.0.15/bin/apache-tomcat-8.0.15.tar.gz 
tar xzf apache-tomcat-8.0.15.tar.gz
rm -f apache-tomcat-8.0.15.tar.gz 
echo "export CATALINA_HOME=\"/usr/share/apache-tomcat-8.0.15\"" >> ~/.bashrc # leaving this as restricted to root


###############################################################################
#############################    GIT     ######################################
###############################################################################

echo "installing git"
yum -y install git # assuming git is stable enough that yum is ok
# need to init bare repo
# project directory is /home/calavera
cd /home/calavera
rm -rf hijo.git   # in case it is already there from previous shared directory interactions
mkdir hijo.git
cd hijo.git
git --bare init

# from http://git-scm.com/book/it/v2/Git-on-the-Server-Setting-Up-the-Server
#adduser git # doing this all as root for now. identities are in version 2
#su git

cd ~
mkdir .ssh && chmod 700 .ssh
touch .ssh/authorized_keys && chmod 600 .ssh/authorized_keys
cp /mnt/public/id_rsa*  ~/.ssh/
cat /mnt/public/id_rsa.pub >> ~/.ssh/authorized_keys

###############################################################################
#############################    JENKINS     ##################################
###############################################################################
#reflecting recommendations from https://wiki.jenkins-ci.org/display/JENKINS/Tomcat

# sudo wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat/jenkins.repo
# sudo rpm --import http://pkg.jenkins-ci.org/redhat/jenkins-ci.org.key
# yum -y install jenkins
cd /usr/share   
echo "downloading & installing Jenkins..."
wget http://mirrors.jenkins-ci.org/war/latest/jenkins.war
#FIX THESE NEXT 2
export CATALINA_OPTS="-DJENKINS_HOME=/usr/share/apache-tomcat-8.0.15/ -Xmx512m"
echo "export CATALINA_OPTS=\"-DJENKINS_HOME=/usr/share/apache-tomcat-8.0.15/ -Xmx512m\"" >> ~/.bashrc 

cd /usr/share/apache-tomcat-8.0.15/webapps
rm -rf *
mv /usr/share/jenkins.war ./ROOT.war

#start tomcat
/usr/share/apache-tomcat-8.0.15/bin/startup.sh


echo "Jenkins should now be available at http://localhost:8183"

#now, configure brazos as slave... 

###############################################################################
#############################   PACKAGE REPO     ##############################
###############################################################################