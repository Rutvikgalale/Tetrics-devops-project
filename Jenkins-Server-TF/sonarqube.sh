#!/bin/bash

apt update -y

sudo fallocate -l 2G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
sudo mount -a
free -h

apt install -y docker.io

systemctl enable docker
systemctl start docker
sudo usermod -aG docker $USER && newgrp docker

docker run -d \
--name sonarqube \
-p 9000:9000 \
sonarqube:lts-community
