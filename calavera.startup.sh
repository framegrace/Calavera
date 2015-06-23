#!/bin/bash
NIC="eth0"
name="dnsmasq"
export MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

[ ! -d dnsmasq.hosts ] && mkdir dnsmasq.hosts
[ -e dnsmasq.hosts/calavera ] && rm dnsmasq.hosts/calavera

# Start dnsmasq server
docker run -v="$(pwd)/dnsmasq.hosts:/dnsmasq.hosts" --name=${name} -p=${MY_IP}':53:5353/udp' -d sroegner/dnsmasq > /tmp/out 2>&1
if [ $? -ne 0 ]
then
  echo "-- Dnsmasq already running"
else
  echo "-- Dnsmasq started"
fi

for NODE in cerebro brazos hombros espina manos cara
do
    echo "-- Iniciant \"${NODE}\""
    vagrant up ${NODE}
    C_IP=`docker inspect --format='{{.NetworkSettings.IPAddress}}' ${NODE}`
    echo "${C_IP} ${NODE} ${NODE}.calavera.biz" >> dnsmasq.hosts/calavera
    docker kill -s HUP dnsmasq
done
