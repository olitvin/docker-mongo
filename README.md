# MongoDB Image
My Docker Images

[NGINX](https://hub.docker.com/r/positron/nginx) -> [PHP-FPM](https://hub.docker.com/r/positron/php) -> [MONGO](https://hub.docker.com/r/positron/mongo)

## Dockerfile
[positron/mongo](https://github.com/positronth/docker-mongo/blob/master/Dockerfile), [positron/mongo:3](https://github.com/positronth/docker-mongo/blob/master/Dockerfile), [positron/mongo:3.4](https://github.com/positronth/docker-mongo/blob/master/Dockerfile), [positron/mongo:latest](https://github.com/positronth/docker-mongo/blob/master/Dockerfile)

## How to use
Network Mode = host

**docker-compose**
```yaml
  mongo1:
    container_name: "mongo1"
    image: positron/mongo
    environment:
      - MONGO_USER=admin
      - MONGO_PASS=password
      - MONGO_DB=test
      - MONGO_PORT=17017
    restart: always
    privileged: true
    volumes:
      - /var/lib/mongo/db1:/data/db
      - /var/lib/mongo/backup1:/data/backup
    network_mode: "host"
```

**docker run**
```
docker run -e MONGO_USER=admin -e MONGO_PASS=password -e MONGO_DB=test -e MONGO_PORT=17017 -v  /var/lib/mongo/db1:/data/db -v /var/lib/mongo/backup1:/data/backup positron/mongo
```
**backup**
backup to "/var/lib/mongo/backup/[folder_name]"
```
docker exec -it [container] /mongo_backup.sh [folder_name]
```
**restore**
restore from "/var/lib/mongo/backup/[folder_name]"
```
docker exec -it [container] /mongo_restore.sh [folder_name]
```

## Package
- Mongo:latest

## Note
**build**
```
sudo docker build -t positron/mongo -t positron/mongo:3 -t positron/mongo:3.4 -t positron/mongo:latest /home/positron/My/Webs/.docker/mongo/
```
**push**
```
sudo docker push positron/mongo
```

for Jarm.com's Server
https://jarm.com
