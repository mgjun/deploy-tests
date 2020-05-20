MASTER_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' redis-master)
SLAVE_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sentinel_redis-slave_1)
SENTINEL_IP=$(docker inspect --format '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' sentinel_redis-slave_1)

echo Redis master: $MASTER_IP
echo Redis Slave: $SLAVE_IP
echo ------------------------------------------------
echo Initial status of sentinel
echo ------------------------------------------------
docker exec sentinel_redis-slave_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec sentinel_redis-slave_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name redismaster
echo ------------------------------------------------

echo Stop redis master
docker pause redis-master
echo Wait for 10 seconds
sleep 10
echo Current infomation of sentinel
docker exec sentinel_redis-slave_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec sentinel_redis-slave_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name redismaster


echo ------------------------------------------------
echo Restart Redis master
docker unpause redis-master
sleep 5
echo Current infomation of sentinel
docker exec sentinel_redis-slave_1 redis-cli -p 26379 info Sentinel
echo Current master is
docker exec sentinel_redis-slave_1 redis-cli -p 26379 SENTINEL get-master-addr-by-name redismaster