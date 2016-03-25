#!/bin/bash
echo "Updating resolv.conf"
NIC="eth0"
name="dnsmasq"
export MY_IP=$(ifconfig $NIC | grep 'inet addr:'| grep -v '127.0.0.1' | cut -d: -f2 | awk '{ print $1}')

grep "$MY_IP" /etc/resolv.conf >/dev/null 2>&1 || sed -i '/nameserver/inameserver '$MY_IP'' /etc/resolv.conf
grep "calavera.biz" /etc/resolv.conf >/dev/null 2>&1 || sed -i '/^search/ s/$/ calavera.biz/' /etc/resolv.conf

