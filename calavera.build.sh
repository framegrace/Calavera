#!/bin/bash
NIC="eth0"
name="dnsmasq"
export MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')
[ ! -d dnsmasq.hosts ] && mkdir dnsmasq.hosts
[ -e dnsmasq.hosts/calavera ] && rm dnsmasq.hosts/calavera

#echo -n "nameserver $MY_IP
#nameserver 172.31.0.2
#search eu-west-1.compute.internal calavera.biz" > /etc/resolv.conf

grep "$MY_IP" /etc/resolv.conf >/dev/null 2>&1 || sed -i '/nameserver/inameserver '$MY_IP'' /etc/resolv.conf
grep "calavera.biz" /etc/resolv.conf >/dev/null 2>&1 || sed -i '/^search/ s/$/ calavera.biz/' /etc/resolv.conf

echo "$MY_IP "`hostname`" "`hostname -f` > dnsmasq.hosts/myself
echo "-- Destroying current environment"
docker ps -a --filter "name=dnsmasq" |grep dnsmasq > /dev/null 2>&1
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

docker kill -s HUP dnsmasq
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
    ./calavera.up.sh ${NODE}
done
