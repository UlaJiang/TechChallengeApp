#!/bin/bash
sudo service docker start
sudo docker pull ulajiang0419/servian_app:v1
sudo docker run  -d -p 80:3000 ulajiang0419/servian_app:v1
