#!/bin/bash
NIC="eth0"
export MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

vagrant halt -f
vagrant destroy -f
[ -d .vagrant ] && rm -rf .vagrant
for NODE in cerebro brazos hombros espina manos cara
do
    echo "-- Construint \"${NODE}\""
    vagrant up --no-provision ${NODE}
    vagrant reload ${NODE}
    C_IP=`docker inspect --format='{{.NetworkSettings.IPAddress}}' ${NODE}`
    echo "${C_IP} ${NODE} ${NODE}.calavera.biz" >> dnsmasq.hosts/calavera
    docker kill -s HUP dnsmasq
done
