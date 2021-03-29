#!/bin/bash
sudo service docker start
sudo chmod 666 /var/run/docker.sock
cd /home/ec2-user/
docker-compose pull
docker-compose up -d