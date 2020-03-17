# sterge toate containerele existente
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)

# creeaza containerul influxdb
docker run -d \
  --name=influxdb \
  -p 8086:8086 \
  -v influx-vol:/var/lib/influxdb \
  influxdb

# asteapta crearea containerului
for i in {10..1}
do
   echo "Waiting for initialization: $i"
   sleep 1
done

# creeaza baza de date - aici o si creez - nush dc nu o vede
curl -POST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"

sleep 2

# creeaza container grafana
docker run -d -v grafana-vol:/var/lib/grafana -p 3000:3000 --link influxdb --name=grafana grafana/grafana

# adauga in retea
docker network connect monitoring influxdb
# conectare la reteaua de monitoring  
docker network connect monitoring grafana

# porneste telegraf
telegraf --config telegraf.config 
