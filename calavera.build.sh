#!/bin/bash
NIC="eth0"
name="dnsmasq"
export MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
[ ! -d dnsmasq.hosts ] && mkdir dnsmasq.hosts
[ -e dnsmasq.hosts/calavera ] && rm dnsmasq.hosts/calavera

echo "-- Destroying current environment"
docker ps |grep dnsmasq > /dev/null 2>&1
if [ $? -eq "0" ] 
then
  echo -n " -- Removing dnsmasq container :"
  docker stop dnsmasq > /dev/null
  docker rm dnsmasq > /dev/null
  echo "Ok"
fi

# Start dnsmasq server
echo -n " -- Starting dnsmasq container :"
docker run -v="$(pwd)/dnsmasq.hosts:/dnsmasq.hosts" --name=${name} -p=${MY_IP}':53:5353/udp' -d sroegner/dnsmasq > /tmp/out 2>&1
if [ $? -ne 0 ]
then
  echo "Error"
  cat /tmp/out
  exit 1
else
  echo "Ok"
fi

echo -n " -- Stopping all running nodes :"
vagrant halt -f > /tmp/out 2>&1
if [ $? -ne 0 ]
then
  echo "Error"
  cat /tmp/out
  exit 1
else
  echo "Ok"
fi
echo -n " -- Removing all nodes :"
vagrant destroy -f > /tmp/out 2>&1
if [ $? -ne 0 ]
then
  echo "Error"
  cat /tmp/out
  exit 1
else
  echo "Ok"
fi

#[ -d .vagrant ] && rm -rf .vagrant
echo "-- Re-creating the environment"
for NODE in cerebro brazos hombros espina manos cara
do
    echo "-- Building \"${NODE}\""
    vagrant up --no-provision ${NODE}
    vagrant reload ${NODE}
    echo "-- Adding \"${NODE}\" to dns"
    C_IP=`docker inspect --format='{{.NetworkSettings.IPAddress}}' ${NODE}`
    echo "${C_IP} ${NODE} ${NODE}.calavera.biz" >> dnsmasq.hosts/calavera
    docker kill -s HUP dnsmasq
done
