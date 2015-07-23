NODE=grafana
docker stop $NODE > /dev/null 2>&1
docker rm $NODE > /dev/null 2>&1
docker run -d -p 8022:80 -p 8125:8125/udp -p 8126:8126 --name ${NODE} kamon/grafana_graphite
C_IP=`docker inspect --format='{{.NetworkSettings.IPAddress}}' ${NODE}`
echo "${C_IP} ${NODE} ${NODE}.calavera.biz" > /data/devops/Calavera/dnsmasq.hosts/grafana
docker kill -s HUP dnsmasq
