#!/bin/sh

echo Installing docker and compose
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

apt-get install -y docker-compose 

echo Run compose and start the Nginx web server 
docker-compose up -d
