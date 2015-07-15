[ $# -eq 0 ] && exit 1
NODE=$1
    echo "-- Building \"${NODE}\""
    vagrant up --no-provision ${NODE}
    vagrant reload ${NODE}
    echo "-- Adding \"${NODE}\" to dns"
    C_IP=`docker inspect --format='{{.NetworkSettings.IPAddress}}' ${NODE}`
    echo "${C_IP} ${NODE} ${NODE}.calavera.biz" >> dnsmasq.hosts/calavera
    docker kill -s HUP dnsmasq
