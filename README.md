# Docker container for running Evilginx2

[Evilginx2](https://github.com/kgretzky/evilginx2) - Standalone man-in-the-middle attack framework used for phishing login credentials along with session cookies, allowing for the bypass of 2-factor authentication protection.

***This container runs without any IOCs or Evilginx Eggs + custom IP blacklist to block access to vendor sandboxes (Original from [YCSM](https://github.com/infosecn1nja/ycsm/blob/master/maps/ip_blacklist.conf))***

## Usage

### Start/Stop Evilginx2 container

```shell
cd ./docker-evilginx2
docker-compose up -d
docker-compose down
```

### Get a bash shell in the container

```shell
docker exec -it evilginx2 /bin/bash
```

### Run Evilginx2 in the running container using developer and debug mode
```shell
bash-5.1# evilginx -p /app/phishlets/ -developer -debug
```

### Evilginx2 Config

```shell
./docker-evilginx2/app/
```

### Display Evilginx2 container logs

```shell
docker logs evilginx2
```

### Clean up unused images
```shell
docker image prune -f
```

### Remove all containers + images (clean install)

```shell
./docker-evilginx2/clean.sh
```
