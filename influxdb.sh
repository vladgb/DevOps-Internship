# creeaza containerul daca nu exista
docker run -d -p 8086:8086 -v influxdb:/var/lib/influxdb --name influxdb influxdb
#porneste containerul
docker start influxdb

# cu comanda de mai jos pot face requesturi la influxdb, dar inca nu am reusit sa le transfer in telegraf
# curl -G 'http://localhost:8086/query?pretty=true' --data-urlencode "db=testdb" --data-urlencode "q=SELECT * FROM sensor1"

# citeste de pe localhost:8086 cu telegraf, dar nu am reusit sa fac query-uri specifice
# output in stdout si ./metrics.out 
telegraf --config telegraf.config 
