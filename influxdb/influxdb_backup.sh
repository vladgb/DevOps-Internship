# sterge toate containerele existente
docker container stop $(docker container ls -aq)
docker container rm $(docker container ls -aq)

# cream folderele si fisierele de config pentru ca influxdb sa poata functiona
sudo -v
sudo useradd -rs /bin/false influxdb
sudo mkdir -p /etc/influxdb
docker run --rm influxdb influxd config | sudo tee /etc/influxdb/influxdb.conf
sudo chown influxdb:influxdb /etc/influxdb/*
sudo mkdir -p /var/lib/influxdb
sudo chown influxdb:influxdb /var/lib/influxdb/*
sudo mkdir -p /etc/influxdb/scripts
echo "CREATE DATABASE telegraf;" > /etc/influxdb/scripts/ init.iql docker run --rm -e INFLUXDB_HTTP_AUTH_ENABLED=true -e INFLUXDB_ADMIN_USER=admin -e INFLUXDB_ADMIN_PASSWORD=admin -v /var/lib/influxdb:/var/lib/influxdb -v /etc/influxdb/scripts:/docker-entrypoint-initdb.d influxdb /init-influxdb.sh

# script for getting the influxdb user id
ADDR=$(cat /etc/passwd | grep influxdb)
tokens=( $ADDR )
IFS=':'
CNT=1
USERID="x"
for i in ${tokens[*]}; do 
	CNT=$((CNT+1))
	USERID=$i
	if [ $CNT = 4 ]; then
		break;
	fi 
done
echo $USERID
         
# creeaza containerul
docker run -d -p 8086:8086 --user $USERID:$USERID --name=influxdb -v /etc/influxdb/influxdb.conf:/etc/influxdb/influxdb.conf -v /var/lib/influxdb:/var/lib/influxdb influxdb -config /etc/influxdb/influxdb.conf

# creeaza container grafana si folder pt date
mkdir data
docker run -d --volume "$PWD/data:/var/lib/grafana" -p 3000:3000 --name=grafana --link influxdb grafana/grafana

# asteapta crearea containerului
for i in {10..1}
do
   echo "Waiting for initialization: $i"
   sleep 1
done

# creeaza baza de date
curl -POST http://localhost:8086/query --data-urlencode "q=CREATE DATABASE telegraf"

# cu comanda de mai jos pot face requesturi la influxdb, dar inca nu am reusit sa le transfer in telegraf
# curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=testdb" --data-urlencode "q=SELECT * FROM sensor1"

# citeste de pe localhost:8086 cu telegraf, dar nu am reusit sa fac query-uri specifice
telegraf --config telegraf.config 
